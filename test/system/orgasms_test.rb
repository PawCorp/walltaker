require "application_system_test_case"

class OrgasmsTest < ApplicationSystemTestCase
  setup do
    @orgasm = orgasms(:one)
  end

  test "visiting the index" do
    visit orgasms_url
    assert_selector "h1", text: "Orgasms"
  end

  test "should create orgasm" do
    visit orgasms_url
    click_on "New orgasm"

    check "Is ruined" if @orgasm.is_ruined
    fill_in "Rating", with: @orgasm.rating
    fill_in "User", with: @orgasm.user_id
    click_on "Create Orgasm"

    assert_text "Orgasm was successfully created"
    click_on "Back"
  end

  test "should update Orgasm" do
    visit orgasm_url(@orgasm)
    click_on "Edit this orgasm", match: :first

    check "Is ruined" if @orgasm.is_ruined
    fill_in "Rating", with: @orgasm.rating
    fill_in "User", with: @orgasm.user_id
    click_on "Update Orgasm"

    assert_text "Orgasm was successfully updated"
    click_on "Back"
  end

  test "should destroy Orgasm" do
    visit orgasm_url(@orgasm)
    click_on "Destroy this orgasm", match: :first

    assert_text "Orgasm was successfully destroyed"
  end
end
