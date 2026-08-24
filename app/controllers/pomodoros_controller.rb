# frozen_string_literal: true

# The single page: the timer itself, with today's focus summary and recent
# history below it.
class PomodorosController < ApplicationController
  def show
    @today_minutes = PomodoroSession.minutes_on(Time.zone.today)
    @recent = PomodoroSession.newest_first.limit(20)
  end
end
