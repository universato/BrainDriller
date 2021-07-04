require 'test_helper'

class API::DrillsTest < ActionDispatch::IntegrationTest
  test 'GET /api/drills.json' do
    json_path = api_drills_path(format: :json)
    assert_equal "/api/drills.json", json_path
    get json_path
    assert_response :ok
  end

  test 'GET /api/drills/:id.json' do
    drill_id = drills(:ruby).id
    json_path = api_drill_path(drill_id, format: :json)
    assert_equal "/api/drills/#{drill_id}.json", json_path
    get json_path
    assert_response :ok
  end
end
