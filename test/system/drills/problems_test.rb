# frozen_string_literal: true

require 'application_system_test_case'

class Drills::ProblemsTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  test "solve drill" do
    login_as(users(:smith), scope: :user)

    visit "/drills/#{drills(:ruby).id}/problems"
  end
end
