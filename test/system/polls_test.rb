require "application_system_test_case"

class PollsTest < ApplicationSystemTestCase
  setup do
    @poll = polls(:one)
  end

  test "visiting the index" do
    visit polls_url
    assert_selector "h1", text: "Polls"
  end

  test "creating a Poll" do
    visit polls_url
    click_on "New Poll"

    fill_in "Topic", with: @poll.topic
    click_on "Create Poll"

    assert_text "Poll was successfully created"
    click_on "Back"
  end

  test "updating a Poll" do
    visit polls_url
    click_on "Edit", match: :first

    fill_in "Topic", with: @poll.topic
    click_on "Update Poll"

    assert_text "Poll was successfully updated"
    click_on "Back"
  end

  test "destroying a Poll" do
    visit polls_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Poll was successfully destroyed"
  end
end
