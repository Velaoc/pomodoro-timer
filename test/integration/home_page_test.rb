require "test_helper"

# Replaced at shape time: this app owns the root page, so the foundation
# placeholder's capability markup is gone by design. The app's own tests
# describe what root actually does now.
class HomePageTest < ActionDispatch::IntegrationTest
  test "root page renders" do
    get root_path
    assert_response :success
  end
end
