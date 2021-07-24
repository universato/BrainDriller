# frozen_string_literal: true

require 'application_system_test_case'

class DrillLikesTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  test "solve drill" do
    login_as(users(:admin), scope: :user)

    visit '/drills'
    first(".index-drill").click
    assert_no_text "UnLike"
    click_button "Like"
    assert_no_text "Like"
    click_button "Unlike"
  end
end
