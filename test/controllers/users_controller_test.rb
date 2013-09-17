require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @authority = FactoryGirl.create(:authority)
    @user = FactoryGirl.create(:user)
    @user.authorities << @authority
  end

  test "should get index" do
    get :index, authority_id: @authority.id
    assert_response :success
  end

  test "should get grant" do
    get :grant, authority_id: @authority.id, id: @user.id
    assert_response :success
  end

  test "should get revoke" do
    get :revoke, authority_id: @authority.id, id: @user.id
    assert_response :success
  end

end
