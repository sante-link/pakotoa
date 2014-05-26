require 'spec_helper'

describe CertificateAuthoritiesController, :type => :controller do
  before do
    admin = create(:user)
    sign_in(admin)
  end

  describe 'policy' do
    let(:policy) do
      policy = create(:policy)
      create(:subject_attribute, policy: policy, oid: Oid.find_by(short_name: 'C'), default: 'FR', min: 2, max: 2, strategy: 'match')
      create(:subject_attribute, policy: policy, oid: Oid.find_by(short_name: 'O'), default: 'Pakotoa', strategy: 'match')
      create(:subject_attribute, policy: policy, oid: Oid.find_by(short_name: 'CN'), strategy: 'supplied')
      create(:subject_attribute, policy: policy, oid: Oid.find_by(short_name: 'emailAddress'), strategy: 'supplied')
      policy
    end
    let!(:ca) { create(:certificate_authority, policy: policy, subject: '/C=FR/O=Pakotoa/CN=Test Root CA/emailAddress=pakotoa@example.com') }

    it 'signs certificates if the policy is matched' do
      expect {
        post :create, certificate_authority: { subject: '/C=FR/O=Pakotoa/OU=Unit/CN=Test CA/emailAddress=pakotoa@example.com', issuer_id: ca.id }
        expect(assigns(:certificate_authority).errors.full_messages).to eq([])
      }.to change(CertificateAuthority,:count).by(1)
    end

    it 'fail if the policy is not matched' do
      expect {
        post :create, certificate_authority: { subject: '/C=FR/O=Not Pakotoa/OU=Unit/CN=Test CA/emailAddress=pakotoa@example.com', issuer_id: ca.id }
      }.to_not change(CertificateAuthority,:count)
    end
  end
end
