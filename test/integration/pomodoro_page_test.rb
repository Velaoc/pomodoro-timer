require "test_helper"

# The root page is the product: a timer and its history. These tests
# describe what root actually does now that the foundation placeholder is gone.
class PomodoroPageTest < ActionDispatch::IntegrationTest
  test "root renders the timer and history" do
    get root_path
    assert_response :success
    assert_select "h1", text: /Pomodoro/
    assert_select "button[data-action='pomodoro#start']", text: "Start"
  end

  test "creating a session records it" do
    assert_difference -> { PomodoroSession.count }, 1 do
      post pomodoro_sessions_path, params: { session: { kind: "work", planned_minutes: 25 } }, as: :json
    end
    assert_response :success
    body = JSON.parse(response.body)
    assert body["ok"]
    assert_equal "work", body["session"]["kind"]
  end

  test "invalid session is rejected" do
    assert_no_difference -> { PomodoroSession.count } do
      post pomodoro_sessions_path, params: { session: { kind: "nap", planned_minutes: 25 } }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test "history index returns sessions and today total" do
    day = Time.zone.today
    PomodoroSession.create!(kind: "work", planned_minutes: 25, completed_at: day.midday)
    PomodoroSession.create!(kind: "short_break", planned_minutes: 5, completed_at: day.midday + 1.hour)

    get pomodoro_sessions_path, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 2, body["sessions"].length
    assert_equal 25, body["today_minutes"]
  end
end
