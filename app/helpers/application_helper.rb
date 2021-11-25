# frozen_string_literal: true

module ApplicationHelper
  ##
  # Translates a flash message key into a Bulma-friendly
  # is-class variable
  #
  # @see https://bulma.io/documentation/elements/notification/
  #
  def bulma_flash_class(key)
    key = key.to_sym # Ensure we are working with a symbol

    case key
    when :alert
      :warning
    when :error
      :danger
    when :notice
      :success
    else
      key
    end
  end

  def format_phone_number(phone_number)
    return phone_number if phone_number.blank?

    clean_phone_number = phone_number.tr('^0-9', '')
    if clean_phone_number.size == 10 # Regular phone number
      "(#{clean_phone_number[0..2]}) #{clean_phone_number[3..5]}-#{clean_phone_number[6..9]}"
    else # Return what's in the database
      phone_number
    end
  end
end
