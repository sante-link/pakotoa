class Certificate < ActiveRecord::Base
  belongs_to :issuer, class_name: 'CertificateAuthority'

  attr_accessor :method, :csr, :export_name

  before_validation do
    if certificate_changed? then
      cert = self.certificate

      self.subject    = Certificate.unescape_utf8_chars(cert.subject.to_s)
      self.serial     = cert.serial.to_s(16)
      self.not_before = cert.not_before
      self.not_after  = cert.not_after
    end
  end

  before_create do
    res = true

    # The serial number is an integer assigned by the CA to each certificate.
    # It MUST be unique for each certificate issued by a given CA (i.e., the
    # issuer name and serial number identify a unique certificate).

    if Certificate.where(issuer_id: issuer_id, serial: serial).any? then
      errors.add(:serial, 'already taken')
      res = false
    end

    # Also check that the certificate subject will not clash with another
    # certificate
    if Certificate.where(issuer_id: issuer_id, subject: subject).any? then
      errors.add(:subject, 'clash with another certificate')
      res = false
    end

    res
  end

  after_create do
    if issuer && !export_name.blank? && !issuer.export_root.blank? then
      filename = File.join(issuer.export_root, export_name)
      Rails.logger.info("Exporting signed certificate to #{filename}")
      FileUtils.mkdir_p(File.dirname(filename))
      open(filename, 'w') do |io|
        io.write(certificate.to_pem)
      end
    end
  end

  def certificate
    OpenSSL::X509::Certificate.new(read_attribute(:certificate))
  end

  def certificate=(certificate)
    write_attribute(:certificate, certificate.to_pem)
  end

  def self.unescape_utf8_chars(s)
    raise "Unsafe certificate subject: #{s}" if s =~ /}/
    eval('%{' + s + '}')
  end
end
