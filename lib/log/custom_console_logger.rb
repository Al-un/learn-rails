# ------------------------------------------------------------------------------
# Custom logger for default Ruby logger kept for learning purpose
# ------------------------------------------------------------------------------

# Tutorial https://www.thegreatcodeadventure.com/building-a-custom-logger-in-rails/
# Custom Rails logger

module Log
  class CustomConsoleLogger < ActiveSupport::Logger

    # Override initialize from
    # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/logger.rb
    def initialize(*args)
      super(*args)
      # Override formatter but leave it opened to overriding
      @formatter = CustomFormatter.new
    end

    # Custom format taken from
    # https://www.thegreatcodeadventure.com/building-a-custom-logger-in-rails/#definingandsettingthecustomformatter
    class CustomFormatter < ::Logger::Formatter

      def call(severity, timestamp, progname, msg)
        # `sprintf` formats string
        # https://apidock.com/ruby/Kernel/sprintf
        formatted_severity = sprintf("%-5s",severity.to_s)

        # `%L`to display milliseconds
        # http://ruby-doc.org/core-2.1.5/Time.html#method-i-strftime
        formatted_time = timestamp.strftime("%Y-%m-%d %H:%M:%S.%L")

        # Double dollar sign is the current process ID: important for multithreading !
        # http://ruby-doc.org/core-2.3.1/doc/globals_rdoc.html
        "[#{$$}] #{formatted_time} #{formatted_severity}| #{msg}\n"
      end

    end

  end
end
