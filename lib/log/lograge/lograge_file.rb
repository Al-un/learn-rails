# ------------------------------------------------------------------------------
# Custom logger for Lograge kept for learning purpose
# ------------------------------------------------------------------------------

module Log
  # attempt to have a dedicated lograge file logger
  class LogrageFile < ActiveSupport::Logger

    def initialize(*args)
      super(*args)
      @formatter = JsonFormatter.new
    end

    class JsonFormatter < ::Logger::Formatter

      def call(severity, timestamp, progname, msg)
        msg.merge({pid: $$}).to_json.to_s + "\n"
      end

    end

  end
end
