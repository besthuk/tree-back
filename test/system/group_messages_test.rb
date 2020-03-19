require "application_system_test_case"

class GroupMessagesTest < ApplicationSystemTestCase
  setup do
    @group_message = group_messages(:one)
  end

  test "visiting the index" do
    visit group_messages_url
    assert_selector "h1", text: "Group Messages"
  end

  test "creating a Group message" do
    visit group_messages_url
    click_on "New Group Message"

    click_on "Create Group message"

    assert_text "Group message was successfully created"
    click_on "Back"
  end

  test "updating a Group message" do
    visit group_messages_url
    click_on "Edit", match: :first

    click_on "Update Group message"

    assert_text "Group message was successfully updated"
    click_on "Back"
  end

  test "destroying a Group message" do
    visit group_messages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Group message was successfully destroyed"
  end
end
