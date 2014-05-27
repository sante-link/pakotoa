class CertificateAuthority < Certificate
  has_many :affiliations, dependent: :destroy
  has_many :users, through: :affiliations
  has_many :certificates, dependent: :destroy, foreign_key: "issuer_id"
  belongs_to :policy

  validates :password, confirmation: true

  attr_accessor :key_length, :password, :issuer_password, :valid_until

  after_initialize do
    self.key_length ||= 2048
    self.next_serial ||= 1
    self.valid_until ||= '20 years from now'
  end

  def next_serial!
    serial = self.next_serial.try(:to_i)
    update_attributes!(next_serial: (next_serial || 0) + 1)
    return serial
  end

  def key=(key)
    if self.password.blank? then
      write_attribute(:key, key.to_pem)
    else
      cipher = OpenSSL::Cipher::Cipher.new('AES-128-CBC')
      write_attribute(:key, key.export(cipher, self.password))
    end
  end

  def key
    k = read_attribute(:key)
    if k then
      return OpenSSL::PKey::RSA.new(read_attribute(:key), self.password)
    else
      return nil
    end
  end

  # Checks that the given OpenSSL::X509::Name match the certificate authority
  # policy.
  def match_policy(subject)
    return true if policy.nil?

    match_re_parts = []
    policy.subject_attributes.order(:position).each do |attr|
      case attr.strategy
      when 'match' then
        match_re_parts << "/#{attr.oid.short_name}=([^/]*)"
      when 'supplied' then
        match_re_parts << "/#{attr.oid.short_name}=[^/]*"
      when 'optional' then
        match_re_parts << "(?:/#{attr.oid.short_name}=[^/]*)?"
      end
    end
    re = Regexp.new(match_re_parts.join)

    subject_matches = re.match(subject.to_s)
    return false if subject_matches.nil?

    # When creating a self-signed CA, we don't have yet a certificate with a
    # subject to check against, however the issuer subject being supposed to be
    # the certificate's subject, the previous verification if the policy
    # matching the DN fields should be enougth.
    if self.certificate then
      issuer_matches = re.match(self.certificate.subject.to_s)
      raise "certification Authority \"#{self.subject}\" does not respect it's own policy!" if issuer_matches.nil?
      return issuer_matches.captures == subject_matches.captures
    end

    return true
  end

  def sign(certificate)
    if match_policy(certificate.subject) then
      certificate.sign(self.key, OpenSSL::Digest::SHA256.new)
    else
      raise "does not respect CA policy"
    end
  end

  def sign_certificate_request(req, export_name = nil)
    req = OpenSSL::X509::Request.new(req)

    cert = OpenSSL::X509::Certificate.new
    cert.version = 2
    cert.serial = self.next_serial!
    cert.subject = req.subject
    cert.issuer = self.certificate.subject
    cert.public_key = req.public_key
    cert.not_before = Time.now
    cert.not_after = Chronic.parse(certify_for)
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = cert
    ef.issuer_certificate = self.certificate
    cert.add_extension(ef.create_extension("keyUsage","digitalSignature", true))
    cert.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
    sign(cert)

    self.certificates.create(certificate: cert, export_name: export_name)
  rescue Exception => e
    res = self.certificates.build
    res.errors.add(:csr, e.message)
    res
  end

  def crl
    crl = OpenSSL::X509::CRL.new
    crl.version = 0
    crl.issuer = certificate.subject
    crl.last_update = Time.now.utc
    crl.next_update = Time.now.utc + 1.week # FIXME
    certificates.where('revoked_at IS NOT NULL').each do |cert|
      rev = OpenSSL::X509::Revoked.new
      rev.serial = cert.certificate.serial
      rev.time = cert.revoked_at

      crl.add_revoked(rev)
    end
    crl.sign(key, OpenSSL::Digest::SHA256.new)
    crl
  end

  def self.import(path)
    CertificateAuthority.transaction do
      logger.debug "Importing CA from #{path}"

      cert = OpenSSL::X509::Certificate.new(File.read("#{path}/cacert.pem"))
      key = OpenSSL::PKey::RSA.new(File.read("#{path}/private/cakey.pem"))

      authority = CertificateAuthority.create!(subject: unescape_utf8_chars(cert.subject.to_s), serial: cert.serial.to_s(16), certificate: cert.to_pem, key: key.to_pem, next_serial: Integer(File.read("#{path}/serial"), 16))

      Dir.glob("#{path}/newcerts/*.pem").each do |filename|
        logger.debug "+ Adding vertificate #{filename}"

        cert = OpenSSL::X509::Certificate.new(File.read(filename))

        authority.certificates.create(subject: unescape_utf8_chars(cert.subject.to_s), serial: cert.serial.to_s(16), certificate: cert.to_pem)
      end
    end
  end

  # The import method will not detect which certificate signed which.  Use
  # reassociate to fix these relationships.
  def self.reassociate
    CertificateAuthority.transaction do
      CertificateAuthority.all.each do |ca|
        cert = OpenSSL::X509::Certificate.new(ca.certificate)

        issuer = CertificateAuthority.find_by(subject: unescape_utf8_chars(cert.issuer.to_s))

        raise "CertificateAuthority #{cert.subject} was issued by an unknown issuer #{cert.issuer}" if issuer.nil?

        next if issuer == ca # issue == nil for self-signed certificates

        ca.update_attributes!(issuer: issuer)
      end
    end
  end
end
