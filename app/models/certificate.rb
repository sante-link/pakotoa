# frozen_string_literal: true

class Certificate < ActiveRecord::Base
  belongs_to :issuer, class_name: "CertificateAuthority", optional: true

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
      errors.add(:serial, "already taken")
      res = false
    end

    # Also check that the certificate subject will not clash with another
    # certificate
    if Certificate.where("issuer_id = ? AND subject = ? AND revoked_at IS NULL AND not_after > ?", issuer_id, subject, Time.now).any? then
      errors.add(:subject, "clash with another valid certificate")
      res = false
    end

    res
  end

  after_create do
    if issuer && !export_name.blank? && !issuer.export_root.blank? then
      filename = File.join(issuer.export_root, export_name)
      Rails.logger.info("Exporting signed certificate to #{filename}")
      FileUtils.mkdir_p(File.dirname(filename))
      open(filename, "w") do |io|
        io.write(certificate.to_pem)
      end
    end
  end

  scope :signed_by, lambda { |issuer|
    ca = CertificateAuthority.unscoped.find_by(subject: issuer)
    where("issuer_id = ? OR (issuer_id IS NULL AND subject = ?)", ca.id, issuer)
  }

  def certificate
    pem = read_attribute(:certificate)
    return nil if pem.nil?
    OpenSSL::X509::Certificate.new(pem)
  end

  def certificate=(certificate)
    write_attribute(:certificate, certificate.to_pem)
  end

  # OpenSSL subject is returned as a partially encoded UTF-8 string:
  #
  #     "/C=FR/O=Sant\\xC3\\xA9Link/O=..."
  #
  # eval is a straightforward solution but for the sake of paranoïa, convert
  # each encoded byte to an UTF-8 char ("\xC3\xA9" -> "Ã©"), then encode the
  # whole string in a non-UTF-8 one ("Ã©" -> "\xC3\xA9"), the force the
  # encoding to UTF-8 ("\xC3\xA9" -> "é").  Win!
  #
  # The ISO-8859-1 encoding may however not work for all situations.  Revert to
  # the legacy code if this is a concern.
  def self.unescape_utf8_chars(s)
    s.gsub(/\\x(..)/) { Integer($1, 16).chr("UTF-8") }.encode("ISO-8859-1").force_encoding("UTF-8")

    # raise "Unsafe certificate subject: #{s}" if s =~ /}/
    # eval('%{' + s + '}')
  end
end
