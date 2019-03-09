require 'test_helper'

class UrlAddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get url_addresses_index_url
    assert_response :success
  end

  test "should get new" do
    get url_addresses_new_url
    assert_response :success
  end

  test "should get create" do
    get url_addresses_create_url
    assert_response :success
  end

end
