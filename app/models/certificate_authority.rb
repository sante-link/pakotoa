class CertificateAuthority < Certificate
  has_many :affiliations, dependent: :destroy
  has_many :users, through: :affiliations
  has_many :certificates, dependent: :destroy, foreign_key: "issuer_id"
  has_many :subject_attributes, dependent: :destroy

  validates :password, confirmation: true

  attr_accessor :key_length, :password, :issuer_password

  after_initialize do
    self.key_length ||= 2048
    self.next_serial ||= 1
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

  def sign(certificate)
    certificate.sign(self.key, OpenSSL::Digest::SHA256.new)
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
