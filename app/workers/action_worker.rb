# frozen_string_literal: true

class ActionWorker < ApplicationWorker
  sidekiq_options retry: 3, backtrace: true

  def perform(run_id)
    run = Run.find(run_id)
    run.execute_next_action
  end
end
