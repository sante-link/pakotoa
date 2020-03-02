Étantdonné(/^un administrateur$/) do
  admin = create(:user)

  visit '/users/sign_in'

  fill_in 'Email', with: admin.email
  fill_in 'Password', with: admin.password

  click_on 'Log in'
end

Lorsqu(/^il visite la page des certificats de l'autorité de certification "([^"]*)"$/) do |subject|
  ca = CertificateAuthority.find_by(subject: subject)
  visit(certificate_authority_certificates_path(ca))
end

Alors(/^il voit (\d+) liens "(.*?)"$/) do |n, text|
  expect(page).to have_xpath('//a', text: text, count: n)
end

