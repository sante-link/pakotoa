Étantdonné(/^un administrateur$/) do
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:medispo, { uid: 1, info: { email: 'user@example.com'}, extra: { raw_info: { roles: ['medispo_administrator'] } }})
  visit user_omniauth_authorize_path(:medispo)
end

Lorsqu(/^il visite la page des certificats de l'autorité de certification "([^"]*)"$/) do |subject|
  ca = CertificateAuthority.find_by(subject: subject)
  visit(certificate_authority_certificates_path(ca))
end

Alors(/^il voit (\d+) liens "(.*?)"$/) do |n, text|
  expect(page).to have_xpath('//a', text: text, count: n)
end

