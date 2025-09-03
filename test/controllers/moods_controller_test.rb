require "test_helper"

class MoodsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get moods_index_url
    assert_response :success
  end
end
