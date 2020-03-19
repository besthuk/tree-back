require 'test_helper'

class GroupMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_message = group_messages(:one)
  end

  test "should get index" do
    get group_messages_url
    assert_response :success
  end

  test "should get new" do
    get new_group_message_url
    assert_response :success
  end

  test "should create group_message" do
    assert_difference('GroupMessage.count') do
      post group_messages_url, params: { group_message: {  } }
    end

    assert_redirected_to group_message_url(GroupMessage.last)
  end

  test "should show group_message" do
    get group_message_url(@group_message)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_message_url(@group_message)
    assert_response :success
  end

  test "should update group_message" do
    patch group_message_url(@group_message), params: { group_message: {  } }
    assert_redirected_to group_message_url(@group_message)
  end

  test "should destroy group_message" do
    assert_difference('GroupMessage.count', -1) do
      delete group_message_url(@group_message)
    end

    assert_redirected_to group_messages_url
  end
end
