DIGITS = Transform /^\d+$/ do |arg|
  arg.to_i
end
