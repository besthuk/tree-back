require "application_system_test_case"

class RelationshipTypesTest < ApplicationSystemTestCase
  setup do
    @relationship_type = relationship_types(:one)
  end

  test "visiting the index" do
    visit relationship_types_url
    assert_selector "h1", text: "Relationship Types"
  end

  test "creating a Relationship type" do
    visit relationship_types_url
    click_on "New Relationship Type"

    click_on "Create Relationship type"

    assert_text "Relationship type was successfully created"
    click_on "Back"
  end

  test "updating a Relationship type" do
    visit relationship_types_url
    click_on "Edit", match: :first

    click_on "Update Relationship type"

    assert_text "Relationship type was successfully updated"
    click_on "Back"
  end

  test "destroying a Relationship type" do
    visit relationship_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Relationship type was successfully destroyed"
  end
end
