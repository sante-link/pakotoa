Étantdonné(/^un certificat "([^"]*)" signé par "(.*?)"$/) do |subject, issuer_subject|
  create(:certificate, issuer_id: CertificateAuthority.find_by(subject: issuer_subject).id, subject: subject)
end

Étantdonné(/^le certificat "([^"]*)" est révoqué$/) do |subject|
  Certificate.find_by(subject: subject).update_attributes(revoked_at: Time.now)
end
