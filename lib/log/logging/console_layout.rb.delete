module Log
  module Logging
    # customize Console layout to handle Hashes
    class ConsoleLayout < ::Logging::Layouts::Pattern

      LOGRAGE_REJECT = [:log_type, :sql_queries, :sql_queries_count]

      # Override https://github.com/TwP/logging/blob/master/lib/logging/layout.rb#L156
      def format_obj( obj )
        # Customize Lograge hashes handling
        if obj.is_a?(Hash) && obj.key?(:log_type)
          lines = []
          lines << obj.reject { |key, _val| LOGRAGE_REJECT.include?(key) }
                      .map{ |key, val| "#{key}: #{val}" }
                      .join(', ')
          # https://apidock.com/ruby/Kernel/sprintf
          lines << obj[:sql_queries].map do |sql_query|
            sprintf('%<duration>6.2fms %<name>25s %<sql>s', sql_query)
          end if obj.key?(:sql_queries)
          
          lines.join("\n\t")
        # Leave it to default implementation
        else
          super(obj)
        end
      end

    end
  end
end
