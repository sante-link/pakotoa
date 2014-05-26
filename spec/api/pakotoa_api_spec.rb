require 'spec_helper'

describe Pakotoa::V10 do
  before(:all) do
    @headers = { 'Accept-Version' => '1.0' }
  end

  let(:key) { OpenSSL::PKey::RSA.new(1024) }
  let(:csr) do
    csr = OpenSSL::X509::Request.new
    csr.subject = OpenSSL::X509::Name.parse('/C=FR/O=Test/OU=Pakotoa/CN=nil/emailAddress=nil@example.com')
    csr.public_key = key.public_key
    csr.sign(key, OpenSSL::Digest::SHA256.new)
  end
  let(:ca) { create(:certificate_authority) }
  let(:certificate) { create(:certificate, issuer: ca) }

  describe 'public API endpoints' do
    it 'returns the current API version' do
      get 'api/version', {}, @headers
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({ 'version' => '1.0' })
    end

    it 'returns certificate authority CRL' do
      get 'api/certificate_authorities/crl', { issuer: ca.subject }
      expect(response.status).to eq(200)
      expect {
        OpenSSL::X509::CRL.new(JSON.parse(response.body)['crl'])
      }.to_not raise_error
    end
  end

  describe 'unauthorized requests' do
    it 'denies certificates signing' do
      post 'api/certificate_authorities/sign', { csr: csr, issuer: ca.subject }, @headers
      expect(response.status).to eq(401)
    end

    it 'denies certificates revokation' do
      patch 'api/certificate_authorities/revoke', { issuer: ca.subject, subject: certificate.subject }, @headers
      expect(response.status).to eq(401)
    end
  end

  describe 'authenticated requests' do
    let(:application) { create(:application) }
    let :token do
      create(:token, application: application)
    end

    describe 'certificates signature' do
      it 'signs valid certificates requests' do
        post 'api/certificate_authorities/sign', { access_token: token.token, csr: csr, issuer: ca.subject }, @headers
        expect(response.status).to eq(201)
      end
      it 'requires a valid certificate authority' do
        post 'api/certificate_authorities/sign', { access_token: token.token, csr: csr, issuer: '/C=XX' }, @headers
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'certificate authority not found' })
      end
      it 'requires a unique certificate subject' do
        create(:certificate, subject: '/C=FR/O=Test/OU=Pakotoa/CN=nil/emailAddress=nil@example.com', issuer: ca)
        post 'api/certificate_authorities/sign', { access_token: token.token, csr: csr, issuer: ca.subject }, @headers
        expect(response.status).to eq(400)
      end
    end

    describe 'certificates revokation' do
      it 'revokes certificates by subject' do
        patch 'api/certificate_authorities/revoke', { access_token: token.token, issuer: ca.subject, subject: certificate.subject }, @headers
        expect(response.status).to eq(200)
      end
      it 'revokes certificates by serial' do
        patch 'api/certificate_authorities/revoke', { access_token: token.token, issuer: ca.subject, serial: certificate.serial }, @headers
        expect(response.status).to eq(200)
      end
      it 'requires valid certificate authority' do
        patch 'api/certificate_authorities/revoke', { access_token: token.token, issuer: '/C=XX', serial: certificate.serial }, @headers
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'certificate authority not found' })
      end
      it 'requires valid issuer' do
        ca2 = create(:certificate_authority)
        patch 'api/certificate_authorities/revoke', { access_token: token.token, issuer: ca2.subject, serial: certificate.serial }, @headers
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'certificate not found' })
      end
      it 'requires subject or serial' do
        patch 'api/certificate_authorities/revoke', { access_token: token.token, issuer: ca.subject }, @headers
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'serial or subject must be set' })
      end
    end
  end
end
