require 'test_helper'

class PredictionControllerTest < ActionController::TestCase
  test "should get retrieve_prediction" do
    get :retrieve_prediction
    assert_response :success
  end

end
