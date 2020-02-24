# frozen_string_literal: true

require "rails_helper"

describe CertificatesController, type: :controller do
  before do
    # FIXME: Hardcoded ID
    admin = FactoryBot.create(:user, id: 1)
    sign_in(admin)
  end

  let(:policy) do
    policy = FactoryBot.create(:policy)

    FactoryBot.create(:subject_attribute, policy: policy, position: 1, oid: Oid.find_by(short_name: "C"), default: "FR", min: 2, max: 2, strategy: "match")
    FactoryBot.create(:subject_attribute, policy: policy, position: 2, oid: Oid.find_by(short_name: "O"), strategy: "match")
    FactoryBot.create(:subject_attribute, policy: policy, position: 3, oid: Oid.find_by(short_name: "OU"), strategy: "optional")
    FactoryBot.create(:subject_attribute, policy: policy, position: 4, oid: Oid.find_by(short_name: "CN"), strategy: "supplied")
    FactoryBot.create(:subject_attribute, policy: policy, position: 5, oid: Oid.find_by(short_name: "emailAddress"), strategy: "supplied")

    policy
  end
  let!(:ca) { FactoryBot.create(:certificate_authority, subject: "/C=FR/O=Pakotoa/CN=Test CA/emailAddress=pakotoa@example.com", policy: policy) }
  let(:key) { OpenSSL::PKey::RSA.new(1024) }
  let(:csr) do
    csr = OpenSSL::X509::Request.new
    csr.subject = OpenSSL::X509::Name.parse(csr_subject)
    csr.public_key = key.public_key
    csr.sign(key, OpenSSL::Digest::SHA256.new)
  end

  describe "policy" do
    describe "matching" do
      let(:csr_subject) { "/C=FR/O=Pakotoa/CN=Test Certificate/emailAddress=pakotoa@example.com" }
      it "signes CSR when policy is matched" do
        payload = {
          certificate_authority_id: ca,
          certificate: { method: "csr", csr: csr }
        }
        expect {
          post :create, params: payload
        }.to change(Certificate, :count).by(1)
      end
    end

    describe "mismatching" do
      let(:csr_subject) { "/C=FR/O=Pakotoa/OU=Extra/OU=More/CN=Test Certificate/emailAddress=pakotoa@example.com" }
      it "fail if the policy is not matched" do
        payload = {
          certificate_authority_id: ca,
          certificate: { method: "csr", csr: csr }
        }
        expect {
          post :create, params: payload
        }.to_not change(Certificate, :count)
      end
    end
  end
end
