# frozen_string_literal: true

require 'application_system_test_case'

class DrillsTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  test "create drill" do
    login_as(users(:smith), scope: :user)

    visit '/drills/new'
    fill_in "drill-title", with: "Drill Title"
    fill_in "drill-guide", with: "Drill Guide"
    click_button "問題を追加していく"
  end

  test "update drill" do
    user = users(:uni)
    login_as(user, scope: :user)
    visit "/drills/#{user.drills.last.id}"
    click_link "編集する"
    click_button "編集画面へ"
    within(:css, 'form#drill-form') do
      fill_in "drill-title", with: "Drill Title"
      fill_in "drill-guide", with: "Drill Guide"
    end
    click_button "下書きで保存する", match: :first
    click_button "公開で保存する", match: :first
  end

  test "solve drill" do
    login_as(users(:smith), scope: :user)

    visit 'drills'
    click_on "Firsts"
    find(".solve-btn").click

    # 1st problem
    assert_text "Correct"
    assert_text "わからない"
    assert_text "中断して採点する"
    first(".problem-choice").click

    # 2nd problem
    assert_text "Correct"
    assert_text "わからない"
    assert_text "中断して採点する"
    first(".problem-choice").click

    # 3rd problem
    assert_no_text "中断して採点する"
    assert_text "採点する"
    first(".problem-choice").click
    assert_no_text "中断して採点する"
    assert_text "採点する"
    click_button "採点する"

    # result
  end
end
