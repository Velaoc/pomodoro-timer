# frozen_string_literal: true

# A completed pomodoro countdown. Guests run the timer without an account,
# so sessions are anonymous by design.
class PomodoroSession < ApplicationRecord
  KINDS = %w[work short_break long_break].freeze

  validates :kind, inclusion: { in: KINDS }
  validates :planned_minutes, numericality: { greater_than: 0 }
  validates :completed_at, presence: true

  scope :work, -> { where(kind: "work") }
  scope :on, ->(day) { where(completed_at: day.all_day) }
  scope :newest_first, -> { order(completed_at: :desc) }

  def self.minutes_on(day)
    work.on(day).sum(:planned_minutes)
  end

  def kind_label
    {
      "work" => "Focus",
      "short_break" => "Short break",
      "long_break" => "Long break"
    }.fetch(kind, kind)
  end
end
