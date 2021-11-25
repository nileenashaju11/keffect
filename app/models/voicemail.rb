# frozen_string_literal: true

class Voicemail < Action
  include Rails.application.routes.url_helpers
  has_one_attached :audio_file

  # validates :audio_file, presence: true, blob: { content_type: :audio }

  def execute(**kwargs)
    run = kwargs[:run]
    slybroadcast = Slybroadcast::Campaign.new
    response = slybroadcast.create(
      run.lead.phone_number,
      audio_file_path,
      audio_file_content_type
    )
    formatted_response(response)
  end

  ##
  # Formats the response to be helpful where needed. Unique to the Slybroadcast
  # response API to extract error responses more cleanly.
  #
  def formatted_response(response)
    error = response.body&.ERROR
    OpenStruct.new(
      success?: response.success?,
      status: response.status,
      error: error&.strip,
      raw: response
    )
  end

  ##
  # Translates ActiveStorage content type into a compatable Slybroadcast type
  #
  def audio_file_content_type
    if wav_audio_types.include?(audio_file.content_type)
      'wav'
    elsif mp3_audio_types.include?(audio_file.content_type)
      'mp3'
    elsif m4a_audio_types.include?(audio_file.content_type)
      'm4a'
    else
      audio_file.content_type
    end
  end

  ##
  # Returns the proper url to the audio file. With different hosting services
  # for development and production this method fixes discrepancies between
  # how the URLs are generated
  #
  def audio_file_path
    return audio_file.service_url if Rails.env.production?

    polymorphic_url(audio_file, only_path: true)
  end

  private

  def supported_audio_types
    mp3_audio_types + m4a_audio_types + wav_audio_types
  end

  def mp3_audio_types
    [
      'audio/mp3',
      'audio/mpeg3',
      'audio/mpg',
      'audio/x-mp3',
      'audio/x-mpeg',
      'audio/x-mpeg3',
      'audio/x-mpg'
    ]
  end

  def m4a_audio_types
    ['audio/x-m4a']
  end

  def wav_audio_types
    ['audio/s-wav', 'audio/wave', 'audio/x-wav']
  end
end
