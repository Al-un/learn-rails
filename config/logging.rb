Logging::Rails.configure do |config|

  # Configure the Logging framework with the default log levels
  Logging.init %w[debug info warn error fatal]

  # Objects will be converted to strings using the :inspect method.
  Logging.format_as :inspect

  # Custom color scheme
  # https://github.com/TwP/logging/blob/master/lib/logging/color_scheme.rb#L211
  # Colours set for dark theme console.
  Logging.color_scheme('dark',
    levels: {
      debug: :white,
      info: :bright_green,
      warn: :bright_yellow,
      error: :bright_red,
      fatal: [:white, :on_red]
    },
    pid: :white,
    date: :white,
    logger: :magenta,
    message: :bright_white
  )
  # Colours set for dark theme console. Much easier, the whole line has a single colour
  Logging.color_scheme(
    'dark_by_lines',
    lines: {
      debug: :white,
      info: :bright_green,
      warn: :bright_yellow,
      error: :bright_red,
      fatal: [:white, :on_red]
    }
  )
  # default color scheme from generator
  Logging.color_scheme( 
    'bright',
    levels: {
      info: :green,
      warn: :yellow,
      error: :red,
      fatal: [:white, :on_red]
    },
    date: :blue,
    logger: :cyan,
    message: :magenta
)

  # Console appender
  if config.log_to.include? 'stdout'
    if Rails.env.development?
      Logging.appenders.stdout( 
        'stdout',
        auto_flushing: true,
        layout: Log::Logging::ConsoleLayout.new(
          pattern: '[%d] %-5l %c: %m\n',
          date_pattern: '%H:%M:%S.%L',
          color_scheme: 'dark'
        )
      )
    else
      # no need to colorise non-development console
      Logging.appenders.stdout(
        'stdout',
        auto_flushing: true,
        layout: Log::Logging::ConsoleLayout.new(
          pattern: '[%p:%t][%d] %-5l %c#%L: %m\n',
          date_pattern: '%Y-%m-%dT%H:%M:%S.%L'
        )
      )
    end
  end

  # Rolling file appender
  if config.log_to.include? 'file'
    Logging.appenders.rolling_file(
      'file',
      filename: ENV['LOGGING_FILE_NAME'],
      keep: ENV['LOGGING_FILE_RETENTION_DAYS'],
      age: 'daily',
      size: ENV['LOGGING_FILE_MAX_SIZE'],
      truncate: false,
      auto_flushing: true,
      layout: Logging.layouts.json
    )
  end

  # Root
  Logging.logger.root.level = config.log_level
  Logging.logger.root.appenders = config.log_to unless config.log_to.empty?

  # Phusion Passenger smart spawning
  if defined? PhusionPassenger
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      Logging.reopen if forked
    end
  end
end
