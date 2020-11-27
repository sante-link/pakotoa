# frozen_string_literal: true

require "rails_helper"

RSpec.describe Certificate do
  let(:ca) { FactoryBot.create :certificate_authority }

  describe ".full_chain_pem" do
    let(:certificate_authority_with_issuers) do
      issuer = FactoryBot.create :certificate_authority, issuer: ca
      FactoryBot.create :certificate, issuer: issuer
    end

    context "when certificate has no issuer" do
      it "returns a correct full chain" do
        result = ca.full_chain_pem.scan("BEGIN CERTIFICATE").count
        expect(result).to eq 1
      end
    end

    context "when certificate has many issuers" do
      it "returns a correct full chain" do
        result = certificate_authority_with_issuers.full_chain_pem.scan("BEGIN CERTIFICATE").count
        expect(result).to eq 3
      end
    end

    context "when certificate is a ca" do
      it "returns a correct full chain" do
        intermediate = FactoryBot.create :certificate_authority, issuer: ca
        result = intermediate.full_chain_pem.scan("BEGIN CERTIFICATE").count
        expect(result).to eq 2
      end
    end
  end
end
