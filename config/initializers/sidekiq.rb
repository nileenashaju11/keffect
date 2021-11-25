# frozen_string_literal: true

Sidekiq.configure_client do |config|
  Sidekiq::Status.configure_client_middleware config
end

Sidekiq.configure_server do |config|
  Sidekiq::Status.configure_server_middleware config
  Sidekiq::Status.configure_client_middleware config
end
