module Log
  module Logging
    # customize Console layout to handle Hashes
    class ConsoleLayout < ::Logging::Layouts::Pattern

      LOGRAGE_REJECTED_KEYS = [:log_type, :sql_queries, :sql_queries_count]

      # Override https://github.com/TwP/logging/blob/master/lib/logging/layout.rb#L156
      def format_obj( obj )
        # Customize Lograge hashes handling
        if obj.is_a?(Hash)
          if obj.key?(:log_type)
            lines = []
            lines << obj.reject { |k, _v| LOGRAGE_REJECTED_KEYS.include?(k) }
                        .map{ |k, v| "#{k}: #{v}" }
                        .join(', ')
            # https://apidock.com/ruby/Kernel/sprintf
            lines << obj[:sql_queries].map do |sql_query|
              sprintf('%<duration>6.2fms %<name>25s %<sql>s', sql_query)
            end if obj.key?(:sql_queries)
            lines.join("\n\t")
          else
            super(obj)
          end
        # Leave it to default implementation
        else
          super(obj)
        end
      end

    end
  end
end
