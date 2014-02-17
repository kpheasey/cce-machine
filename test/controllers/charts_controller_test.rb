require 'test_helper'

class ChartsControllerTest < ActionController::TestCase
  test "should get line" do
    get :line
    assert_response :success
  end

  test "should get candlestick" do
    get :candlestick
    assert_response :success
  end

end
