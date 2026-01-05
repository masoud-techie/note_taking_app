require "test_helper"

class NoteSharesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get note_shares_create_url
    assert_response :success
  end

  test "should get destroy" do
    get note_shares_destroy_url
    assert_response :success
  end
end
