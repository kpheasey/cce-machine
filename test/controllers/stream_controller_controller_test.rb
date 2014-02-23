require 'test_helper'

class StreamControllerControllerTest < ActionController::TestCase
  test "should get exchange" do
    get :exchange
    assert_response :success
  end

  test "should get market" do
    get :market
    assert_response :success
  end

  test "should get exchange_market" do
    get :exchange_market
    assert_response :success
  end

end
