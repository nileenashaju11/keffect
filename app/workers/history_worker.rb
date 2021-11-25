# frozen_string_literal: true

class HistoryWorker < ApplicationWorker
  sidekiq_options queue: 'history'

  def perform(klass_name, subject_id, text)
    # Find object for History
    subject = klass_name.safe_constantize.find_by(id: subject_id)
    return if subject.nil?

    # Save History
    History.create(subject: subject, text: text)
  end
end
