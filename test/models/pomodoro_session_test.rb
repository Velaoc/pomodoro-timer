require "test_helper"

class PomodoroSessionTest < ActiveSupport::TestCase
  test "valid session" do
    session = PomodoroSession.new(kind: "work", planned_minutes: 25, completed_at: Time.current)
    assert session.valid?
  end

  test "kind must be one of the known kinds" do
    assert_not PomodoroSession.new(kind: "nap", planned_minutes: 25, completed_at: Time.current).valid?
    assert_not PomodoroSession.new(kind: nil, planned_minutes: 25, completed_at: Time.current).valid?
  end

  test "planned_minutes must be positive" do
    assert_not PomodoroSession.new(kind: "work", planned_minutes: 0, completed_at: Time.current).valid?
  end

  test "minutes_on sums only work sessions for the day" do
    day = Time.zone.today
    PomodoroSession.create!(kind: "work", planned_minutes: 25, completed_at: day.midday)
    PomodoroSession.create!(kind: "work", planned_minutes: 50, completed_at: day.midday + 1.hour)
    PomodoroSession.create!(kind: "short_break", planned_minutes: 5, completed_at: day.midday + 2.hours)

    assert_equal 75, PomodoroSession.minutes_on(day)
  end
end
