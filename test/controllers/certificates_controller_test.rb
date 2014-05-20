require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  setup do
    @certificate_authority = FactoryGirl.create(:certificate_authority)
    @certificate = FactoryGirl.create(:certificate, certificate_authority: @certificate_authority)

    @admin = FactoryGirl.create(:user)

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
    skip
    assert_difference('Certificate.count') do
      post :create, certificate_authority_id: @certificate_authority.id, certificate: { serial: "A85B60641B41E609" }
    end

    assert_redirected_to certificate_authority_certificate_path(@certificate_authority, assigns(:certificate))
  end

  test "should show certificate" do
    get :show, certificate_authority_id: @certificate_authority.id, id: @certificate
    assert_response :success
  end

  test "should get edit" do
    get :edit, certificate_authority_id: @certificate_authority.id, id: @certificate
    assert_response :success
  end

  test "should update certificate" do
    patch :update, certificate_authority_id: @certificate_authority.id, id: @certificate, certificate: { certificate_authority_id: @certificate.certificate_authority_id, serial: @certificate.serial }
    assert_redirected_to certificate_authority_certificate_path(@certificate_authority, assigns(:certificate))
  end

  test "should destroy certificate" do
    assert_difference('Certificate.count', -1) do
      delete :destroy, certificate_authority_id: @certificate_authority.id, id: @certificate
    end

    assert_redirected_to certificate_authority_certificates_path(@certificate_authority)
  end
end
