require 'test_helper'

class GroupUserRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_user_request = group_user_requests(:one)
  end

  test "should get index" do
    get group_user_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_group_user_request_url
    assert_response :success
  end

  test "should create group_user_request" do
    assert_difference('GroupUserRequest.count') do
      post group_user_requests_url, params: { group_user_request: {  } }
    end

    assert_redirected_to group_user_request_url(GroupUserRequest.last)
  end

  test "should show group_user_request" do
    get group_user_request_url(@group_user_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_user_request_url(@group_user_request)
    assert_response :success
  end

  test "should update group_user_request" do
    patch group_user_request_url(@group_user_request), params: { group_user_request: {  } }
    assert_redirected_to group_user_request_url(@group_user_request)
  end

  test "should destroy group_user_request" do
    assert_difference('GroupUserRequest.count', -1) do
      delete group_user_request_url(@group_user_request)
    end

    assert_redirected_to group_user_requests_url
  end
end
