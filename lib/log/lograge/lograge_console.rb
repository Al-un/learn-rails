# ------------------------------------------------------------------------------
# Custom logger for Lograge kept for learning purpose
# ------------------------------------------------------------------------------

module Log
  # attempt to have a dedicated lograge console logger
  class LogrageConsole < ActiveSupport::Logger

    def initialize(*args)
      super(*args)
      @formatter = CustomFormatter.new
    end

    class CustomFormatter < ::Logger::Formatter

      def call(severity, timestamp, progname, msg)
        puts "====================== formatting: #{msg.inspect}"
        formatted_severity = sprintf("%-5s",severity.to_s)
        formatted_time = timestamp.strftime("%Y-%m-%d %H:%M:%S.%L")
        "[#{$$}] #{formatted_time} #{formatted_severity}| #{msg}\n"
      end

    end

  end
end
