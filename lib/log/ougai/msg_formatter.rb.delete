# frozen_string_literal: true

module Log
  module Ougai
    # Formatting main log message in console. In this project, @plain is never
    # false and coloring is always used.
    class MsgFormatter < ::Ougai::Formatters::Readable::MessageFormatter
      LOGRAGE_REJECT = [:sql_queries, :sql_queries_count]

      def call(severity, datetime, _progname, data)
        # Remove :msg regardless the outcome
        msg = data.delete(:msg)
        # Lograge specfic stuff: main controller output handled by msg formatter
        if data.key?(:request)
          lograge = data[:request].reject { |k, _v| LOGRAGE_REJECT.include?(k) }
                                  .map { |key, val| "#{key}: #{val}" }
                                  .join(', ')
          msg = @color_config.color(:msg, lograge, severity) 
        # Standard text
        else
          msg = @color_config.color(:msg, msg, severity)
        end

        # Standardize output
        format('%-5s %s: %s',
               @color_config.color(:severity, severity, severity), 
               @color_config.color(:datetime, datetime, severity), 
               msg)
      end
    end
  end
end
