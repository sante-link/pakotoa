# frozen_string_literal: true

Étantdonné(/^(\d+) minutes s'écoulent$/) do |n|
  Timecop.travel(n.minutes.from_now)
end
