require "test_helper"

class ErrorLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get error_logs_new_url
    assert_response :success
  end

  test "should get create" do
    get error_logs_create_url
    assert_response :success
  end

  test "should get show" do
    get error_logs_show_url
    assert_response :success
  end

  test "should get stream" do
    get error_logs_stream_url
    assert_response :success
  end

  test "should get ranking" do
    get error_logs_ranking_url
    assert_response :success
  end
end
