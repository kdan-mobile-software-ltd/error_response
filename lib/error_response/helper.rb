# frozen_string_literal: true

require 'active_support/concern'

module ErrorResponse
  module Helper
    extend ActiveSupport::Concern

    included do
      rescue_from RequestError do |e|
        error_response(e.key, e.error_message, e.error_data)
      end
    end

    def success_response(data = {})
      render status: 200, json: { data: data }
    end

    def error_response(key, error_message = nil, error_data = {})
      render_content = ErrorResponse.to_api(key, error_message).deep_dup
      if error_data.is_a?(Hash) && !error_data.empty?
        render_content[:json] = render_content[:json].merge(error_data)
      elsif error_data.is_a?(Array) && !error_data.empty?
        render_content[:json] = render_content[:json].merge(error_data: error_data)
      end
      render(render_content)
    end
  end
end
