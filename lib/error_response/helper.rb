# frozen_string_literal: true

require 'active_support'

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
      render_content[:json].merge!(error_data) if error_data.present? && error_data.is_a?(Hash)
      render_content[:json].merge!(error_data: error_data) if error_data.present? && error_data.is_a?(Array)
      render(render_content)
    end
  end
end
