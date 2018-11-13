Rails.application.configure do
  puts ' ===[AppConfig]=== development.rb - start'

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Logging --------------------------------------------------------------------
  puts ' ===[AppConfig]=== Loggers'
  # # ==== Standard Ruby Logger
  # logger_file = ActiveSupport::TaggedLogging.new(Log::CustomFileLogger.new(Rails.root.join('log/plop.log')))
  # logger_console = ActiveSupport::TaggedLogging.new(Log::CustomConsoleLogger.new(STDOUT))
  # logger_file.level = :info
  # logger_console.level = :info
  # logger_console.extend(ActiveSupport::Logger.broadcast(logger_file))
  # config.logger = logger_console

  # # === Log4r
  # log4r_config = YAML.load_file(File.join(Rails.root, 'config', 'log4r.yml'))
  # YamlConfigurator.decode_yaml( log4r_config["log4r_config"] )
  # config.logger = Log4r::Logger[Rails.env]

  # # === Logging
  # # Set the logging destination(s)
  # config.log_to = %w[stdout file]
  # # Show the logging configuration on STDOUT
  # config.show_log_configuration = true

  # === Lograge
  # see config/initializers/lograge.rb

  # === Ougai
  # console_logger  = Log::OugaiConsoleLogger.new(STDOUT)
  # file_logger = Log::OugaiFileLogger.new(Rails.root.join('log/ougai_dev.log'))
  color_config = Ougai::Formatters::Colors::Configuration.new(
    severity: {
      trace:  Ougai::Formatters::Colors::WHITE,
      debug:  Ougai::Formatters::Colors::GREEN,
      info:   Ougai::Formatters::Colors::CYAN,
      warn:   Ougai::Formatters::Colors::YELLOW,
      error:  Ougai::Formatters::Colors::RED,
      fatal:  Ougai::Formatters::Colors::PURPLE
    },
    msg: :severity,
    datetime: {
      default:  Ougai::Formatters::Colors::PURPLE,
      error:  Ougai::Formatters::Colors::RED,
      fatal:  Ougai::Formatters::Colors::RED
    }
  )

  EXCLUDED_FIELD = []
  LOGRAGE_REJECT = [:sql_queries, :sql_queries_count]

  console_formatter = Ougai::Formatters::Customizable.new(
    format_msg: proc do |severity, datetime, _progname, data|
      # Remove :msg regardless the outcome
      msg = data.delete(:msg)
      # Lograge specfic stuff: main controller output handled by msg formatter
      if data.key?(:request)
        lograge = data[:request].reject { |k, _v| LOGRAGE_REJECT.include?(k) }
                                .map { |key, val| "#{key}: #{val}" }
                                .join(', ')
        msg = color_config.color(:msg, lograge, severity) 
      # Standard text
      else
        msg = color_config.color(:msg, msg, severity)
      end

      # Standardize output
      format('%-5s %s: %s',
             color_config.color(:severity, severity, severity),
             color_config.color(:datetime, datetime, severity),
             msg)
    end,
    format_data: proc do |data|
      # Lograge specfic stuff: main controller output handled by msg formatter
      if data.key?(:request)
        lograge_data = data[:request]
        if lograge_data.key?(:sql_queries)
          lograge_data[:sql_queries].map do |sql_query|
            format('%<duration>6.2fms %<name>25s %<sql>s (%<type_casted_binds>s)', sql_query)
          end
          .join("\n")
        else
          nil
        end
      # Default styling
      else
        EXCLUDED_FIELD.each { |field| data.delete(field) }
        next nil if data.empty?

        data.ai
      end
    end
  )
  # console_formatter = Ougai::Formatters::Readable.new(
  #   color_config: console_color,
  #   msg_formatter: Log::Ougai::MsgFormatter.new(console_color),
  #   data_formatter: proc do |data|
  #     # Lograge request detected
  #     if data.key?(:request)
  #       data[:request].reject { |k, _v| k == :not_required_key }
  #                     .map { |key, val| "#{key}: #{val}" }
  #                     .join(', ')
  #     else
  #       data.ai
  #     end
  #   end
  # )
  # console_formatter = Ougai::Formatters::Readable.new
  console_formatter.datetime_format = '%H:%M:%S.%L'
  file_formatter            = Ougai::Formatters::Bunyan.new
  file_logger               = Log::Ougai::Logger.new(Rails.root.join('log/ougai_dev.log'))
  file_logger.formatter     = file_formatter
  console_logger            = Log::Ougai::Logger.new(STDOUT)
  console_logger.formatter  = console_formatter
  # testing default configuration: 
  # console_logger.formatter  = Ougai::Formatters::Readable.new
  console_logger.extend(Ougai::Logger.broadcast(file_logger))
  config.logger = console_logger

  # Loggly
  # see config/initializers/loggly.rb

  puts ' ===[AppConfig]=== development.rb - end'
end
