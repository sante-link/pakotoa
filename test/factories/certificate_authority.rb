FactoryGirl.define do
  factory :certificate_authority do
    subject '/C=FR/O=Pakotoa/OU=Factory/CN=Test CA Certificate'

    after(:build) do |certificate|
      key = OpenSSL::PKey::RSA.new(1024)

      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = 2
      cert.subject = OpenSSL::X509::Name.parse(certificate.subject)
      cert.issuer = cert.subject
      cert.not_before = Time.now
      cert.not_after = Time.now + 1.hour
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = cert
      cert.add_extension(ef.create_extension("basicConstraints", "CA:TRUE", true))
      cert.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
      cert.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      cert.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))
      cert.sign(key, OpenSSL::Digest::SHA256.new)

      certificate.key = key
      certificate.certificate = cert
    end
  end
end
