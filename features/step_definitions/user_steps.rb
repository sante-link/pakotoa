Étantdonné(/^un utilisateur$/) do
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:medispo, { uid: 1, info: { email: 'user@example.com'}, extra: { raw_info: { roles: ['medispo_administrator'] } }})
end

