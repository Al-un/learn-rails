# frozen_string_literal: true

module Log
  module Ougai
    class MsgFormatter < ::Ougai::Formatters::Colored::MessageFormatter
      LOGRAGE_REJECT = [:sql_queries, :sql_queries_count]
      
      def call(datetime, severity, msg, _progname, data)
        level = severity
        unless @plain
          datetime  = @color_config.color(:datetime, datetime, severity)
          msg       = @color_config.color(:msg, msg, severity)
          level     = @color_config.color(:severity, level, severity)
        end

        # Lograge specfic stuff: main controller output handled by msg formatter
        if data.key?(:request)
          lograge_str = data[:request].reject { |key, _val| LOGRAGE_REJECT.include?(key) }
                                      .map{ |key, val| "#{key}: #{val}" }
                                      .join(', ')
          msg = @plain ? lograge_str : @color_config.color(:msg, lograge_str, severity) 
        end

        # Standardize output
        format('%-5s %s: %s', level, datetime, msg)
      end
    end
  end
end
