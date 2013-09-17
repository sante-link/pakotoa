require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  setup do
    @authority = FactoryGirl.create(:authority)
    @certificate = FactoryGirl.create(:certificate, authority: @authority)

    @admin = FactoryGirl.create(:user)

    sign_in(@admin)
  end

  test "should get index" do
    get :index, authority_id: @authority.id
    assert_response :success
    assert_not_nil assigns(:certificates)
  end

  test "should get new" do
    get :new, authority_id: @authority.id
    assert_response :success
  end

  test "should create certificate" do
    assert_difference('Certificate.count') do
      post :create, authority_id: @authority.id, certificate: { serial: "A85B60641B41E609" }
    end

    assert_redirected_to authority_certificate_path(@authority, assigns(:certificate))
  end

  test "should show certificate" do
    get :show, authority_id: @authority.id, id: @certificate
    assert_response :success
  end

  test "should get edit" do
    get :edit, authority_id: @authority.id, id: @certificate
    assert_response :success
  end

  test "should update certificate" do
    patch :update, authority_id: @authority.id, id: @certificate, certificate: { authority_id: @certificate.authority_id, serial: @certificate.serial }
    assert_redirected_to authority_certificate_path(@authority, assigns(:certificate))
  end

  test "should destroy certificate" do
    assert_difference('Certificate.count', -1) do
      delete :destroy, authority_id: @authority.id, id: @certificate
    end

    assert_redirected_to authority_certificates_path(@authority)
  end
end
