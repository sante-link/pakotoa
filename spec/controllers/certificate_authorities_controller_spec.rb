require 'rails_helper'

describe CertificateAuthoritiesController, :type => :controller do
  before do
    admin = create(:user, id: 1)
    sign_in(admin)
  end

  describe 'policy' do
    let(:policy) do
      policy = create(:policy)
      create(:subject_attribute, policy: policy, position: 1, oid: Oid.find_by(short_name: 'C'), default: 'FR', min: 2, max: 2, strategy: 'match')
      create(:subject_attribute, policy: policy, position: 2, oid: Oid.find_by(short_name: 'O'), default: 'Pakotoa', strategy: 'match')
      create(:subject_attribute, policy: policy, position: 3, oid: Oid.find_by(short_name: 'OU'), strategy: 'optional')
      create(:subject_attribute, policy: policy, position: 4, oid: Oid.find_by(short_name: 'CN'), strategy: 'supplied')
      create(:subject_attribute, policy: policy, position: 5, oid: Oid.find_by(short_name: 'emailAddress'), strategy: 'supplied')
      policy
    end
    let!(:ca) { create(:certificate_authority, policy: policy, subject: '/C=FR/O=Pakotoa/CN=Test Root CA/emailAddress=pakotoa@example.com') }

    it 'signs certificates if the policy is matched' do
      payload = { certificate_authority: {
        subject: '/C=FR/O=Pakotoa/OU=Unit/CN=Test CA/emailAddress=pakotoa@example.com', issuer_id: ca.id }
      }
      expect {
        post :create, params: payload
      }.to change(CertificateAuthority,:count).by(1)
    end

    it 'fail if the policy is not matched' do
      payload = { certificate_authority: {
        subject: '/C=FR/O=Not Pakotoa/OU=Unit/CN=Test CA/emailAddress=pakotoa@example.com', issuer_id: ca.id }
      }
      expect {
        post :create, params: payload
      }.to_not change(CertificateAuthority,:count)
    end
  end
end
