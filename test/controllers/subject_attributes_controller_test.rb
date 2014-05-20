require 'test_helper'

class SubjectAttributesControllerTest < ActionController::TestCase
  setup do
    load "#{Rails.root}/db/seeds.rb"

    @certificate_authority = FactoryGirl.create(:certificate_authority)
    @subject_attribute = FactoryGirl.create(:subject_attribute, oid: Oid.find_by_name('countryName'), certificate_authority: @certificate_authority, min: 2, max: 2, default: "FR", policy: "match")
    @subject_attribute = FactoryGirl.create(:subject_attribute, oid: Oid.find_by_name('commonName'), certificate_authority: @certificate_authority, policy: "supplied")
    @subject_attribute = FactoryGirl.create(:subject_attribute, oid: Oid.find_by_name('emailAddress'), certificate_authority: @certificate_authority, policy: "optional")

    @admin = FactoryGirl.create(:user)

    sign_in(@admin)
  end

  test "should get index" do
    get :index, certificate_authority_id: @certificate_authority
    assert_response :success
    assert_not_nil assigns(:subject_attributes)
  end

  test "should get new" do
    get :new, certificate_authority_id: @certificate_authority
    assert_response :success
  end

  test "should create subject_attribute" do
    assert_difference('SubjectAttribute.count') do
      post :create, certificate_authority_id: @certificate_authority, subject_attribute: { certificate_authority_id: @subject_attribute.certificate_authority_id, default: @subject_attribute.default, max: @subject_attribute.max, min: @subject_attribute.min, oid_id: @subject_attribute.oid_id, policy: @subject_attribute.policy, position: @subject_attribute.position }
    end

    assert_redirected_to certificate_authority_subject_attribute_path(@certificate_authority, assigns(:subject_attribute))
  end

  test "should show subject_attribute" do
    get :show, certificate_authority_id: @certificate_authority, id: @subject_attribute
    assert_response :success
  end

  test "should get edit" do
    get :edit, certificate_authority_id: @certificate_authority, id: @subject_attribute
    assert_response :success
  end

  test "should update subject_attribute" do
    patch :update, certificate_authority_id: @certificate_authority, id: @subject_attribute, subject_attribute: { certificate_authority_id: @subject_attribute.certificate_authority_id, default: @subject_attribute.default, max: @subject_attribute.max, min: @subject_attribute.min, oid_id: @subject_attribute.oid_id, policy: @subject_attribute.policy, position: @subject_attribute.position }
    assert_redirected_to certificate_authority_subject_attribute_path(@certificate_authority, assigns(:subject_attribute))
  end

  test "should destroy subject_attribute" do
    assert_difference('SubjectAttribute.count', -1) do
      delete :destroy, certificate_authority_id: @certificate_authority, id: @subject_attribute
    end

    assert_redirected_to certificate_authority_subject_attributes_path(@certificate_authority)
  end
end
