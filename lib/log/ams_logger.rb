# frozen_string_literal: true

module Log
  class AmsLogger < ::Logger
    include ActiveSupport::LoggerThreadSafeLevel
    include LoggerSilence

    def debug(progname, &block)
      # only handle Rack-Cors blocks
      if block_given?
        ams_log = yield
        Rails.logger.debug ams_log
      else
        super
      end
    end

    def info(progname, &block)
      # only handle Rack-Cors blocks
      if block_given?
        ams_log = yield
        Rails.logger.info ams_log
      else
        super
      end
    end
  end
end
