require 'log/ams_logger'

Rails.application.configure do
  puts ' ===[AppConfig]=== Initializers: ActiveModelSerializer'
  # https://github.com/rails-api/active_model_serializers/blob/0-10-stable/docs/general/logging.md
  ActiveModelSerializers.logger = Log::AmsLogger.new(STDOUT)
  # ActiveModelSerializers.logger = Rails.logger
end
