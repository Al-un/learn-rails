# ------------------------------------------------------------------------------
# Custom logger for default Ruby logger kept for learning purpose
# ------------------------------------------------------------------------------

# Tutorial https://www.thegreatcodeadventure.com/building-a-custom-logger-in-rails/
# Custom Rails logger

module Log
  class CustomFileLogger < ActiveSupport::Logger

    def initialize(*args)
      super(*args)
      @formatter = JsonFormatter.new
    end

    class JsonFormatter < ::Logger::Formatter

      def call(severity, timestamp, progname, msg)
        # https://stackoverflow.com/a/29855485/4906586
        # timestamp.to_f => otherwise accuracy is limited to seconds only
        {
          pid: $$,
          timestamp: timestamp.to_f,
          formatted_time: timestamp.strftime("%Y-%m-%d %H:%M:%S.%L"),
          severity: severity,
          progname: progname,
          msg: msg
        }.to_json.to_s + "\n"
      end

    end

  end
end
