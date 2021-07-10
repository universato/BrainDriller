# frozen_string_literal: true

require 'application_system_test_case'

class StaticPagesTest < ApplicationSystemTestCase
  test "Get TOS" do
    visit "/tos"
  end

  test "Get policy" do
    visit "/policy"
  end
end
