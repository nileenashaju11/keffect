# frozen_string_literal: true

module Historical
  extend ActiveSupport::Concern

  included do
    has_many :histories, as: :subject, dependent: :destroy

    ##
    # Records a historical event via ActiveJob
    #
    def record_history(text)
      HistoryWorker.perform_async(self.class.name, id, text)
    end

    def display_changes
      saved_changes.map do |k, v|
        # Skip default fields
        next if ['updated_at', 'created_at'].include?(k)

        "#{k.humanize.capitalize}: #{v.first} -> #{v.last}"
      end.compact.join(', ')
    end
  end
end
