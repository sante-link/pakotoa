Étantdonné(/^une autorité de certification "([^"]*)"$/) do |subject|
  create(:certificate_authority, subject: subject)
end

Lorsqu(/^il créé une autorité de certification "([^"]*)"$/) do |subject|
  visit root_path

  click_link 'New Certificate Authority'
  fill_in 'Subject', with: subject
  click_button 'Save'

  expect(page).to have_content('Certificate authority was successfully created.')
end

Lorsqu(/^il créé une autorité de certification "([^"]*)" avec la phrase de passe "([^"]*)"$/) do |subject, password|
  visit root_path

  click_link 'New Certificate Authority'
  fill_in 'Subject', with: subject
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: password
  click_button 'Save'

  expect(page).to have_content('Certificate authority was successfully created.')
end

Lorsqu(/^il créé une autorité de certification "([^"]*)" signée par "([^"]*)" avec la phrase de passe "([^"]*)" en utilisant la phrase de passe "([^"]*)"$/) do |subject, ca_subject, password, ca_password|
  visit root_path

  click_link 'New Certificate Authority'
  fill_in 'Subject', with: subject
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: password
  select ca_subject, from: 'Issuer'
  fill_in 'Issuer password', with: ca_password
  click_button 'Save'

  expect(page).to have_content('Certificate authority was successfully created.')
end

Lorsqu(/^il créé une autorité de certification "([^"]*)" signée par "([^"]*)" en utilisant la phrase de passe "([^"]*)"$/) do |subject, ca_subject, ca_password|
  visit root_path

  click_link 'New Certificate Authority'
  fill_in 'Subject', with: subject
  select ca_subject, from: 'Issuer'
  fill_in 'Issuer password', with: ca_password
  click_button 'Save'

  expect(page).to have_content('Certificate authority was successfully created.')
end

Alors(/^l'autorité de certification "([^"]*)" peut signer une demande de signature de certificat pour "([^"]*)"$/) do |ca_subject, subject|
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

  expect(page).to have_content('Certificate was successfully created.')
end
