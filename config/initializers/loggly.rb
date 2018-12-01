# frozen_string_literal: true

# https://github.com/freeformz/logglier
Rails.application.configure do
  # Environment dependent tagging
  loggy_url = 'https://logs-01.loggly.com/inputs/' + ENV['LOGGLY_TOKEN'] +
              '/tag/learnzone,rails,' + Rails.env
  # Always send in JSON format.
  # [TODO] check if input has to be in Hash
  loggly = Logglier.new(loggy_url, threaded: true, format: :json)
  # Append logger
  Rails.logger.extend(ActiveSupport::Logger.broadcast(loggly))
end
