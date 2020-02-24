# frozen_string_literal: true

FactoryBot.define do
  sequence(:serial) { |x| x.to_s(16) }

  factory :certificate do
    serial
    sequence(:subject) { |n| "/C=FR/O=Pakotoa/OU=Factory/CN=Test Certificate #{n}" }

    after(:build) do |certificate|
      key = OpenSSL::PKey::RSA.new(2048)

      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = Integer(certificate.serial, 16)
      cert.subject = OpenSSL::X509::Name.parse(certificate.subject)
      cert.issuer = certificate.issuer.certificate.subject
      cert.public_key = key.public_key
      cert.not_before = Time.now
      cert.not_after = Time.now + 10.minutes
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = certificate.issuer.certificate
      cert.add_extension(ef.create_extension("keyUsage", "digitalSignature", true))
      cert.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
      certificate.issuer.sign(cert)

      certificate.certificate = cert
    end
  end
end
