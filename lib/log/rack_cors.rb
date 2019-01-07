# frozen_string_literal: true

module Log
  class RackCors < ::Logger
    include ActiveSupport::LoggerThreadSafeLevel
    include LoggerSilence

    def debug(progname, &block)
      # only handle Rack-Cors blocks
      if block_given?
        cors_log = yield
        if cors_log.is_a?(Hash)
          Rails.logger.debug cors: cors_log
        else
          Rails.logger.debug cors_log
        end
      end
    end
  end
end
