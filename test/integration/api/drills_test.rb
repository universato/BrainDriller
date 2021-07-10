require 'test_helper'

class API::DrillsTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  test 'GET /api/drills.json' do
    json_path = api_drills_path(format: :json)
    assert_equal "/api/drills.json", json_path
    get json_path
    assert_response :ok
  end

  test 'GET /api/drills/:id.json' do
    drill = drills(:ruby)
    drill_id = drill.id
    assert_equal "full_open", drill.state
    json_path = api_drill_path(drill_id, format: :json)
    assert_equal "/api/drills/#{drill_id}.json", json_path
    get json_path
    assert_response :ok
  end

  test 'GET /api/drills/:draft_id.json' do
    drill = drills(:draft)
    drill_id = drill.id
    assert_equal "draft", drill.state
    json_path = api_drill_path(drill_id, format: :json)
    assert_equal "/api/drills/#{drill_id}.json", json_path
    get json_path
    assert_response :ok
    # OKではないような
  end

  test 'GET /api/mydrills' do
    login_as(users(:smith), scope: :user)
    get '/api/mydrills'
    assert_response :ok
  end
end
