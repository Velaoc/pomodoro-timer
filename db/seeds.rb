# Optional demo data: a couple of finished sessions so the history and
# today's focus summary render with something real on first boot. Harmless
# if the app runs with an empty database.
if PomodoroSession.count.zero?
  now = Time.current

  [
    { kind: "work", planned_minutes: 25, completed_at: now - 2.days - 3.hours },
    { kind: "work", planned_minutes: 25, completed_at: now - 2.days - 2.hours },
    { kind: "short_break", planned_minutes: 5, completed_at: now - 2.days - 2.hours + 30.minutes },
    { kind: "work", planned_minutes: 25, completed_at: now - 1.day - 4.hours },
    { kind: "work", planned_minutes: 25, completed_at: now - 1.day - 3.hours },
    { kind: "work", planned_minutes: 25, completed_at: now - 30.minutes }
  ].each do |attrs|
    PomodoroSession.create!(**attrs)
  end
end
