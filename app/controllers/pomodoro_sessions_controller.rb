# frozen_string_literal: true

# JSON endpoints the timer uses to persist completed sessions and to load
# history without a full page reload.
class PomodoroSessionsController < ApplicationController
  def create
    session = PomodoroSession.new(session_params)
    session.completed_at = Time.current
    session.save!

    render json: { ok: true, session: session.as_json(only: %i[id kind planned_minutes completed_at]) }
  rescue ActiveRecord::RecordInvalid => e
    render json: { ok: false, errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def index
    sessions = PomodoroSession.newest_first.limit(30)
    render json: {
      sessions: sessions.map { |s| session_payload(s) },
      today_minutes: PomodoroSession.minutes_on(Time.zone.today)
    }
  end

  private

  def session_params
    params.require(:session).permit(:kind, :planned_minutes)
  end

  def session_payload(session)
    {
      id: session.id,
      kind: session.kind,
      kind_label: session.kind_label,
      planned_minutes: session.planned_minutes,
      completed_at: session.completed_at.iso8601
    }
  end
end
