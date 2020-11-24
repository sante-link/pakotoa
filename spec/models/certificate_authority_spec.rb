# frozen_string_literal: true

require "rails_helper"

RSpec.describe CertificateAuthority do
  let(:certificate_authority) { FactoryBot.create :certificate_authority }

  describe ".full_chain_pem" do
    let(:certificate_authority_with_issuers) do
      first = FactoryBot.create :certificate_authority
      second = FactoryBot.create :certificate_authority, issuer: first
      FactoryBot.create :certificate_authority, issuer: second
    end

    context "when certificate has no issuer" do
      it "returns a correct full chain" do
        result = certificate_authority.full_chain_pem.scan("BEGIN CERTIFICATE").count
        expect(result).to eq 1
      end
    end

    context "when certificate has many issuers" do
      it "returns a correct full chain" do
        result = certificate_authority_with_issuers.full_chain_pem.scan("BEGIN CERTIFICATE").count
        expect(result).to eq 3
      end
    end
  end
end
