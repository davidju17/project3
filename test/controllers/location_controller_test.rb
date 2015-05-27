require 'test_helper'

class LocationControllerTest < ActionController::TestCase
  test "should get retrieve_locations" do
    get :retrieve_locations
    assert_response :success
  end

end
