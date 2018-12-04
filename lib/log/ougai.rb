require 'ougai/formatters/colors/configuration'
require 'ougai/formatters/customizable'

module Log
  module Ougai
    # Colors configuration
    COLORS = ::Ougai::Formatters::Colors::Configuration.new(
      severity: {
        trace: ::Ougai::Formatters::Colors::WHITE,
        debug: ::Ougai::Formatters::Colors::GREEN,
        info: ::Ougai::Formatters::Colors::CYAN,
        warn: ::Ougai::Formatters::Colors::YELLOW,
        error: ::Ougai::Formatters::Colors::RED,
        fatal: ::Ougai::Formatters::Colors::PURPLE
      },
      msg: :severity,
      datetime: {
        default: ::Ougai::Formatters::Colors::PURPLE,
        error: ::Ougai::Formatters::Colors::RED,
        fatal: ::Ougai::Formatters::Colors::RED
      }
    )
    # Data formatter: excluded fields
    EXCLUDED_FIELD = []
    # Lograge specific field exclusion
    LOGRAGE_REJECT = [:sql_queries, :sql_queries_count]
    # Main log message format
    MSG_FORMAT = '%<duration>6.2fms %<name>25s %<sql>s (%<type_casted_binds>s)'

    CONSOLE_FORMATTER = ::Ougai::Formatters::Customizable.new(
      format_msg: proc do |severity, datetime, _progname, data|
        # Remove :msg regardless the outcome
        msg = data.delete(:msg)

        # Lograge specfic stuff: main controller output handled by msg formatter
        if data.key?(:request)
          lograge = data[:request].reject { |k, _v| LOGRAGE_REJECT.include?(k) }
                                  .map { |key, val| "#{key}: #{val}" }
                                  .join(', ')
          msg = COLORS.color(:msg, lograge, severity)
          # Standard text
        else
          msg = COLORS.color(:msg, msg, severity)
        end

        # Standardize output
        format('%-5s %s: %s',
               COLORS.color(:severity, severity, severity),
               COLORS.color(:datetime, datetime, severity),
               msg)
      end,
      format_data: proc do |data|
        # Lograge specfic stuff: main controller output handled by msg formatter
        if data.key?(:request)
          lograge_data = data[:request]
          if lograge_data.key?(:sql_queries)
            lograge_data[:sql_queries].map do |sql_query|
              format(MSG_FORMAT, sql_query)
            end
              .join("\n")
          end

          # Default styling
        else
          EXCLUDED_FIELD.each { |field| data.delete(field) }
          next nil if data.empty?

          data.ai
        end
      end
    )
  end
end
