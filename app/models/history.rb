# frozen_string_literal: true

# History is simply a logging mechanism for displaying history for various
# objects.
class History < ApplicationRecord
  belongs_to :subject, polymorphic: true
  validates :text, presence: true
end
