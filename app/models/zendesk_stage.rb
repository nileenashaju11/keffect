# frozen_string_literal: true

class ZendeskStage < ApplicationRecord
  has_many :flows, dependent: :nullify
  has_many :leads, dependent: :nullify
  validates :name, uniqueness: { case_sensitive: false }
end
