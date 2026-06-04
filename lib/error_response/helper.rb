# frozen_string_literal: true

require "active_support/concern"

module ErrorResponse
  module Helper
    extend ActiveSupport::Concern

    # Ensure RequestError is always handled by this helper, even when
    # controllers define broad handlers like rescue_from Exception later.
    def rescue_with_handler(exception, *args, **kwargs, &)
      if exception.is_a?(RequestError)
        error_response(exception.key, exception.error_message, exception.error_data)
        return exception
      end

      super
    end

    def success_response(data = {})
      render status: 200, json: { data: data }
    end

    def error_response(key, error_message = nil, error_data = {})
      resolved_message = ErrorResponse.resolve_error_message(
        key: key,
        error_message: error_message,
        error_data: error_data,
        context: self
      )
      render_content = ErrorResponse.to_api(key, resolved_message).deep_dup
      if error_data.is_a?(Hash) && !error_data.empty?
        render_content[:json] = render_content[:json].merge(error_data)
      elsif error_data.is_a?(Array) && !error_data.empty?
        render_content[:json] = render_content[:json].merge(error_data: error_data)
      end
      render(render_content)
    end
  end
end
