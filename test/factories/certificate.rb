FactoryGirl.define do
  factory :certificate do
    subject '/C=FR/O=Pakotoa/OU=Factory/CN=Test Certificate'

    after(:build) do |certificate|
      key = OpenSSL::PKey::RSA.new(1024)

      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = 2
      cert.subject = OpenSSL::X509::Name.parse(certificate.subject)
      cert.issuer = certificate.issuer.certificate.subject
      cert.public_key = key.public_key
      cert.not_before = Time.now
      cert.not_after = Time.now + 1.hour
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = certificate.issuer.certificate
      cert.add_extension(ef.create_extension("keyUsage","digitalSignature", true))
      cert.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      certificate.issuer.sign(cert)

      certificate.certificate = cert
    end
  end
end
