# frozen_string_literal: true

class FixNotBeforeNotAfterForCertificates < ActiveRecord::Migration[4.2]
  def self.up
    Certificate.all.each do |certificate|
      cert = OpenSSL::X509::Certificate.new(certificate.certificate)
      certificate.update_attributes!(not_before: cert.not_before, not_after: cert.not_after)
    end
  end
end
