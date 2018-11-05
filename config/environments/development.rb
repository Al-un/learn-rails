Rails.application.configure do
  puts ' ---------- Application configuration: Development.rb (start) ----------'

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
  puts ' ---------- Application configuration: Loggers ----------'
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
  console_color = Ougai::Colors::Configuration.new(
    severity: {
      trace:  Ougai::Colors::WHITE,
      debug:  Ougai::Colors::WHITE,
      info:   Ougai::Colors::CYAN,
      warn:   Ougai::Colors::YELLOW,
      error:  Ougai::Colors::RED,
      fatal:  Ougai::Colors::MAGENTA
    },
    msg: :inherited,
    datetime: {
      trace:  Ougai::Colors::WHITE,
      debug:  Ougai::Colors::WHITE,
      info:   Ougai::Colors::WHITE,
      warn:   Ougai::Colors::MAGENTA,
      error:  Ougai::Colors::MAGENTA,
      fatal:  Ougai::Colors::MAGENTA
    },
    irrelevant_key: 'useless value but whatever'
  )
  console_formatter = Ougai::Formatters::Colored.new(
    color_config: console_color,
    msg_formatter: Log::Ougai::MsgFormatter.new(console_color),
    data_formatter: Log::Ougai::DataFormatter.new
  )
  console_formatter.datetime_format = '%H:%M:%S.%L'
  file_formatter            = Ougai::Formatters::Bunyan.new
  file_logger               = Log::Ougai::Logger.new(Rails.root.join('log/ougai_dev.log'))
  file_logger.formatter     = file_formatter
  console_logger            = Log::Ougai::Logger.new(STDOUT)
  console_logger.formatter  = console_formatter
  # testing default configuration: 
  # console_logger.formatter  = Ougai::Formatters::Colored.new
  console_logger.extend(Ougai::Logger.broadcast(file_logger))
  config.logger = console_logger

  # Loggly
  # see config/initializers/loggly.rb

  puts ' ---------- Application configuration: Development.rb (end) ----------'
end
