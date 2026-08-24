class CreatePomodoroSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :pomodoro_sessions do |t|
      t.string :kind, null: false, default: "work"
      t.integer :planned_minutes, null: false, default: 25
      t.datetime :completed_at, null: false

      t.timestamps
    end

    add_index :pomodoro_sessions, :completed_at
    add_index :pomodoro_sessions, :kind
  end
end
