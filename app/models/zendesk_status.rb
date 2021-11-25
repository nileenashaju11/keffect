# frozen_string_literal: true

class ZendeskStatus < ApplicationRecord
  has_many :flows, dependent: :nullify
  validates :status, uniqueness: { case_sensitive: false }
end
