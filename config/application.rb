require_relative 'boot'

require 'rails/all'
# --- Logging stuff
# require 'log4r'
# require 'log4r/yamlconfigurator'
# require 'log4r/outputter/datefileoutputter'
# include Log4r
# require 'logging'
require 'ougai'
require 'ougai/colors'
require 'ougai/colors/configuration'
require 'ougai/formatters/colored'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LearnZone
  class Application < Rails::Application
    puts ' ---------- Application configuration: start ----------'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Custom environment files
    if Rails.env.development? 
      config.before_configuration do
        env_file = File.join(Rails.root, 'config', 'local_env.yml')
        if File.exist?(env_file)
          YAML.safe_load(File.open(env_file)).each do |key, value|
            # Value is required to be a String when provided as an Integer
            ENV[key.to_s] = value.to_s
          end
        end
      end
    end

    # BAD?
    # http://brettu.com/rails-ruby-tips-203-load-lib-files-in-rails-4/
    # config.autoload_paths += %W(#{config.root}/lib)
    # https://blog.bigbinary.com/2016/08/29/rails-5-disables-autoloading-after-booting-the-app-in-production.html
    config.eager_load_paths << Rails.root.join('lib')

    # Display if application is currently offline
    if ENV['OFFLINE_MODE']
      puts '** /!\ Application is currently is Offline/!\ **'
    end

    puts ' ---------- Application configuration: end ----------'
  end
  
end
