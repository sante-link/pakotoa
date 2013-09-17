require 'test_helper'

class SubjectAttributesControllerTest < ActionController::TestCase
  setup do
    @authority = FactoryGirl.create(:authority)
    @subject_attribute = FactoryGirl.create(:subject_attribute, oid_id: 1, authority: @authority, min: 2, max: 2, default: "FR", policy: "match")
    @subject_attribute = FactoryGirl.create(:subject_attribute, oid_id: 6, authority: @authority, policy: "supplied")
    @subject_attribute = FactoryGirl.create(:subject_attribute, oid_id: 7, authority: @authority, policy: "optional")

    @admin = FactoryGirl.create(:user)

    sign_in(@admin)
  end

  test "should get index" do
    get :index, authority_id: @authority
    assert_response :success
    assert_not_nil assigns(:subject_attributes)
  end

  test "should get new" do
    get :new, authority_id: @authority
    assert_response :success
  end

  test "should create subject_attribute" do
    assert_difference('SubjectAttribute.count') do
      post :create, authority_id: @authority, subject_attribute: { authority_id: @subject_attribute.authority_id, default: @subject_attribute.default, max: @subject_attribute.max, min: @subject_attribute.min, oid_id: @subject_attribute.oid_id, policy: @subject_attribute.policy, position: @subject_attribute.position }
    end

    assert_redirected_to authority_subject_attribute_path(@authority, assigns(:subject_attribute))
  end

  test "should show subject_attribute" do
    get :show, authority_id: @authority, id: @subject_attribute
    assert_response :success
  end

  test "should get edit" do
    get :edit, authority_id: @authority, id: @subject_attribute
    assert_response :success
  end

  test "should update subject_attribute" do
    patch :update, authority_id: @authority, id: @subject_attribute, subject_attribute: { authority_id: @subject_attribute.authority_id, default: @subject_attribute.default, max: @subject_attribute.max, min: @subject_attribute.min, oid_id: @subject_attribute.oid_id, policy: @subject_attribute.policy, position: @subject_attribute.position }
    assert_redirected_to authority_subject_attribute_path(@authority, assigns(:subject_attribute))
  end

  test "should destroy subject_attribute" do
    assert_difference('SubjectAttribute.count', -1) do
      delete :destroy, authority_id: @authority, id: @subject_attribute
    end

    assert_redirected_to authority_subject_attributes_path(@authority)
  end
end
