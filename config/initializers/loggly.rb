# frozen_string_literal: true

# https://github.com/freeformz/logglier
Rails.application.configure do

  # Display offline warning
  if ENV['OFFLINE_MODE']
    puts '*** Application is in Offline Mode. Loggly is disabled ***'
  # Offline mode do not support loggly logging
  else
    # Environment dependent tagging
    loggy_url = 'https://logs-01.loggly.com/inputs/' + ENV['LOGGLY_TOKEN'] +
                '/tag/learnzone,rails,' + Rails.env
    # Always send in JSON format.
    # [TODO] check if input has to be in Hash
    loggly = Logglier.new(loggy_url, threaded: true, format: :json)
    # Append logger
    Rails.logger.extend(ActiveSupport::Logger.broadcast(loggly))
  end
end
