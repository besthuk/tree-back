require "application_system_test_case"

class PersonalInfosTest < ApplicationSystemTestCase
  setup do
    @personal_info = personal_infos(:one)
  end

  test "visiting the index" do
    visit personal_infos_url
    assert_selector "h1", text: "Personal Infos"
  end

  test "creating a Personal info" do
    visit personal_infos_url
    click_on "New Personal Info"

    click_on "Create Personal info"

    assert_text "Personal info was successfully created"
    click_on "Back"
  end

  test "updating a Personal info" do
    visit personal_infos_url
    click_on "Edit", match: :first

    click_on "Update Personal info"

    assert_text "Personal info was successfully updated"
    click_on "Back"
  end

  test "destroying a Personal info" do
    visit personal_infos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Personal info was successfully destroyed"
  end
end
