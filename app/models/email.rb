# frozen_string_literal: true

class Email < Action
  ##
  # @return [Faraday::Response] response from API call
  #
  def execute(**kwargs)
    run = kwargs[:run]
    formatted_subject = ActionServices::FormatService.new(
      run,
      subject
    ).execute
    body = ActionServices::FormatService.new(
      run,
      content.body.to_s
    ).execute
    text = ActionServices::FormatService.new(
      run,
      content.body.to_plain_text
    ).execute
    channel_id = Rails.application.credentials.dig(:front, :email_channel_id)
    front = Front::Messages.new(channel_id: channel_id)
    response = front.create(run.lead.email, formatted_subject, body, text)
    formatted_response(response)
  end

  ##
  # Formats the response to be helpful where needed. Unique to the Front response
  # API to extract error responses more cleanly.
  #
  def formatted_response(response)
    error = response.body&._error
    OpenStruct.new(
      success?: response.success?,
      status: response.status,
      error: "#{error&.title} #{error&.message}".strip,
      raw: response
    )
  end
end
