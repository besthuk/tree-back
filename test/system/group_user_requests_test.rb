require "application_system_test_case"

class GroupUserRequestsTest < ApplicationSystemTestCase
  setup do
    @group_user_request = group_user_requests(:one)
  end

  test "visiting the index" do
    visit group_user_requests_url
    assert_selector "h1", text: "Group User Requests"
  end

  test "creating a Group user request" do
    visit group_user_requests_url
    click_on "New Group User Request"

    click_on "Create Group user request"

    assert_text "Group user request was successfully created"
    click_on "Back"
  end

  test "updating a Group user request" do
    visit group_user_requests_url
    click_on "Edit", match: :first

    click_on "Update Group user request"

    assert_text "Group user request was successfully updated"
    click_on "Back"
  end

  test "destroying a Group user request" do
    visit group_user_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Group user request was successfully destroyed"
  end
end
