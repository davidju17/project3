require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get retrieve_data" do
    get :retrieve_data
    assert_response :success
  end

  test "should get get_location_data" do
    get :get_location_data
    assert_response :success
  end

end
