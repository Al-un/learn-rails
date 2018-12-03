# frozen_string_literal: true

require 'lograge/sql/extension'

Rails.application.configure do
  puts ' ===[AppConfig]=== Initializers: Lograge'
  config.lograge.enabled = true
  config.lograge.formatter = Class.new do |fmt|
    def fmt.call(data)
      { request: data }
    end
  end
  # For API only
  # config.lograge.base_controller_class = 'ActionController::API'

  # add additional fields to lograge
  config.lograge.custom_options = lambda do |event|
    # https://www.reddit.com/r/rails/comments/5u1lzn/rails_production_logging_in_2017/ddrrqei
    { remote_ip: event.payload[:remote_ip] }
  end

  # Lograge SQL
  event_extractor = proc do |event|
    # puts '~~~~~~~~'
    # puts event.inspect
    # puts '~~~~~~~~'
    {
      name: event.payload[:name],
      duration: event.duration.to_f.round(2),
      sql: event.payload[:sql],
      type_casted_binds: event.payload[:type_casted_binds].inspect
    }
  end

  config.lograge_sql.extract_event = event_extractor
  config.lograge_sql.formatter = proc do |sql_queries|
    sql_queries
  end

end
