# frozen_string_literal: true

require 'ougai/formatters/colored'

module Log
  module Ougai
    class DataFormatter < ::Ougai::Formatters::Colored::DataFormatter

      def call(data)
        # Lograge specfic stuff: main controller output handled by msg formatter
        if data.key?(:request)
          lograge_data = data[:request]
          if lograge_data.key?(:sql_queries)
            lograge_data[:sql_queries].map do |sql_query|
              format('%<duration>6.2fms %<name>25s %<sql>s', sql_query)
            end
            .join("\n")
          else
            ''
          end
        # Default styling
        else
          super(data)
        end
      end
    end
  end
end
