class Certificate < ActiveRecord::Base
  belongs_to :issuer, class_name: 'CertificateAuthority'

  attr_accessor :method, :csr

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
end
