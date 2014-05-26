Lorsqu(/^il créé une autorité de certification "(.*)"$/) do |subject|
  visit user_omniauth_authorize_path(:medispo)

  click_link 'New Certificate Authority'
  fill_in 'Subject', with: subject
  click_button 'Save'
end

Alors(/^l'autorité de certification "(.*)" peut signer une demande de signature de certificat pour "(.*)"$/) do |ca_subject, subject|
  @certificate_authority = CertificateAuthority.find_by(subject: ca_subject)

  key = OpenSSL::PKey::RSA.new(2048)

  csr = OpenSSL::X509::Request.new
  csr.version = 2
  csr.public_key = key.public_key
  csr.subject = OpenSSL::X509::Name.parse(subject)
  csr.sign(key, OpenSSL::Digest::SHA256.new)

  visit new_certificate_authority_certificate_path(@certificate_authority)
  fill_in 'Csr', with: csr.to_pem

  click_button 'Save'

  expect(page).to have_content(/-----BEGIN CERTIFICATE-----.*-----END CERTIFICATE-----/)
end
