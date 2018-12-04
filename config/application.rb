require_relative 'boot'

require 'rails/all'
# --- Logging stuff
# require 'log4r'
# require 'log4r/yamlconfigurator'
# require 'log4r/outputter/datefileoutputter'
# include Log4r
# require 'logging'
require 'ougai'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LearnZone
  class Application < Rails::Application
    # puts ' ----------------------------------------------------------------------'
    puts ' ===[AppConfig]=== start'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Loading environment variable before Application configuration
    Dotenv::Railtie.load
    puts ' ===[AppConfig]=== loading dotenv'

    # BAD?
    # http://brettu.com/rails-ruby-tips-203-load-lib-files-in-rails-4/
    # config.autoload_paths += %W(#{config.root}/lib)
    # https://blog.bigbinary.com/2016/08/29/rails-5-disables-autoloading-after-booting-the-app-in-production.html
    config.eager_load_paths << Rails.root.join('lib')

    # CORS confguration. Check https://github.com/cyu/rack-cors. Must be at the
    # top
    require 'log/rack_cors'
    cors_logger = Log::RackCors.new(STDOUT)
    config.middleware.insert_before 0, Rack::Cors,
                                    debug: true, logger: cors_logger do
      allow do
        origins ENV['CORS_ALLOWED_ORIGIN'].split(',')
        resource '*',
                 headers: :any,
                 methods: [:get, :post, :patch, :put, :delete],
                 maxAge: 86400
      end
    end
    puts ' ===[AppConfig]=== CORS allowed origin: ' + ENV['CORS_ALLOWED_ORIGIN']

    # For Heroku
    # https://stackoverflow.com/a/19650687/4906586
    config.assets.initialize_on_precompile = false

    # Logging is common for all environments
    puts ' ===[AppConfig]=== Loggers'
    require 'log/ougai/logger'
    require 'log/ougai'
    console_formatter = Log::Ougai::CONSOLE_FORMATTER
    console_formatter.datetime_format = '%H:%M:%S.%L'
    file_formatter = Ougai::Formatters::Bunyan.new
    file_path = 'log/ougai_' + Rails.env
    file_logger = Log::Ougai::Logger.new(Rails.root.join(file_path))
    file_logger.formatter = file_formatter
    console_logger = Log::Ougai::Logger.new(STDOUT)
    console_logger.formatter = console_formatter
    console_logger.extend(Ougai::Logger.broadcast(file_logger))
    config.logger = console_logger

    puts ' ===[AppConfig]=== end'
  end
end
