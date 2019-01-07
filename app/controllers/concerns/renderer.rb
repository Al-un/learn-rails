# frozen_string_literal: true

# Renderer
module Renderer
  # Render according to +html+, +js+ and +json+ format:
  # - +html+ always redirect to either a path (+html_path+) or an object path
  # - +js+ always keeps the default behaviour
  # - +json+ always renders +render json: object+ with the provided options
  #
  # @param [Object] object rendered object(s)
  # @param [Proc] resp_html To be called HTML rendering proc
  # @param [Object] json custom json object to send if not sending the +object+
  # @param [Hash] json_opts optional json parameters
  def respond(object, resp_html: nil, json: nil, json_opts: {})
    respond_to do |format|
      format.html { resp_html&.call }
      format.js
      format.json do
        render json_opts.merge(json: (json || object))
      end
    end
  end
end
