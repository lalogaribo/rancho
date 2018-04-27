require 'test_helper'

class VuelosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vuelos_index_url
    assert_response :success
  end

end
