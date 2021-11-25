# frozen_string_literal: true

# The Flow class represents a pathway that a lead could be entered into. It
# contains many Actions that can be taken in an ordered way.
class Flow < ApplicationRecord
  include Historical

  has_many :actions, -> { order(:order) }, dependent: :destroy, inverse_of: :flow
  has_many :runs, inverse_of: :flow, dependent: :destroy
  has_many :leads, through: :runs, dependent: :destroy
  belongs_to :zendesk_stage, optional: true
end
