require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  setup do
    @certificate_authority = FactoryGirl.create(:certificate_authority)
    @certificate = FactoryGirl.create(:certificate, issuer: @certificate_authority)

    @admin = FactoryGirl.create(:user, id: 1)

    sign_in(@admin)
  end

  test "should get index" do
    get :index, certificate_authority_id: @certificate_authority.id
    assert_response :success
    assert_not_nil assigns(:certificates)
  end

  test "should get new" do
    get :new, certificate_authority_id: @certificate_authority.id
    assert_response :success
  end

  test "should create certificate" do
    assert_difference('Certificate.count') do
      key = OpenSSL::PKey::RSA.new(1024)
      req = OpenSSL::X509::Request.new
      req.subject = OpenSSL::X509::Name.parse('/C=FR/O=Pakotoa/CN=TEST/emailAddress=test@example.com')
      req.public_key = key.public_key
      req.sign(key, OpenSSL::Digest::SHA256.new)
      post :create, certificate_authority_id: @certificate_authority.id, certificate: { method: 'csr', csr: req.to_pem }
    end

    assert_redirected_to certificate_authority_certificate_path(@certificate_authority, assigns(:certificate))
  end

  test "should show certificate" do
    get :show, certificate_authority_id: @certificate_authority.id, id: @certificate
    assert_response :success
  end

  test "should destroy certificate" do
    assert_difference('Certificate.count', -1) do
      delete :destroy, certificate_authority_id: @certificate_authority.id, id: @certificate
    end

    assert_redirected_to certificate_authority_certificates_path(@certificate_authority)
  end
end
