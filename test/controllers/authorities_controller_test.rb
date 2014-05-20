require 'test_helper'

class CertificateAuthoritiesControllerTest < ActionController::TestCase
  setup do
    load "#{Rails.root}/db/seeds.rb"

    @certificate_authority = FactoryGirl.create(:certificate_authority)
    @admin = FactoryGirl.create(:user)
    sign_in(@admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:certificate_authorities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create certificate authority" do
    assert_difference('CertificateAuthority.count') do
      post :create, certificate_authority: { subject: '/C=FR/OU=Pakotoa/CN=Test certificate', key_length: 1024 }
    end

    assert_redirected_to certificate_authority_path(assigns(:certificate_authority))
  end

  test "should show certificate authority" do
    get :show, id: @certificate_authority
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @certificate_authority
    assert_response :success
  end

  test "should update certificate authority" do
    patch :update, id: @certificate_authority, certificate_authority: { name: "New Name" }
    assert_redirected_to certificate_authority_path(assigns(:certificate_authority))
  end

  test "should destroy certificate authority" do
    assert_difference('CertificateAuthority.count', -1) do
      delete :destroy, id: @certificate_authority
    end

    assert_redirected_to certificate_authorities_path
  end
end
