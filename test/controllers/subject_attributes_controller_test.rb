require 'test_helper'

class SubjectAttributesControllerTest < ActionController::TestCase
  setup do
    load "#{Rails.root}/db/seeds.rb"

    @policy = FactoryBot.create(:policy)
    @subject_attribute = FactoryBot.create(:subject_attribute, oid: Oid.find_by_name('countryName'), policy: @policy, min: 2, max: 2, default: "FR", strategy: "match")
    @subject_attribute = FactoryBot.create(:subject_attribute, oid: Oid.find_by_name('commonName'), policy: @policy, strategy: "supplied")
    @subject_attribute = FactoryBot.create(:subject_attribute, oid: Oid.find_by_name('emailAddress'), policy: @policy, strategy: "optional")

    @admin = FactoryBot.create(:user, id: 1)

    sign_in(@admin)
  end

  test "should get index" do
    get :index, policy_id: @policy
    assert_response :success
    assert_not_nil assigns(:subject_attributes)
  end

  test "should get new" do
    get :new, policy_id: @policy
    assert_response :success
  end

  test "should create subject_attribute" do
    assert_difference('SubjectAttribute.count') do
      post :create, policy_id: @policy, subject_attribute: { default: @subject_attribute.default, max: @subject_attribute.max, min: @subject_attribute.min, oid_id: @subject_attribute.oid_id, strategy: @subject_attribute.strategy, position: @subject_attribute.position }
    end

    assert_redirected_to policy_subject_attribute_path(@policy, assigns(:subject_attribute))
  end

  test "should show subject_attribute" do
    get :show, policy_id: @policy, id: @subject_attribute
    assert_response :success
  end

  test "should get edit" do
    get :edit, policy_id: @policy, id: @subject_attribute
    assert_response :success
  end

  test "should update subject_attribute" do
    patch :update, policy_id: @policy, id: @subject_attribute, subject_attribute: { default: @subject_attribute.default, max: @subject_attribute.max, min: @subject_attribute.min, oid_id: @subject_attribute.oid_id, strategy: @subject_attribute.strategy, position: @subject_attribute.position }
    assert_redirected_to policy_subject_attribute_path(@policy, assigns(:subject_attribute))
  end

  test "should destroy subject_attribute" do
    assert_difference('SubjectAttribute.count', -1) do
      delete :destroy, policy_id: @policy, id: @subject_attribute
    end

    assert_redirected_to policy_subject_attributes_path(@policy)
  end
end
