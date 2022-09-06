# frozen_string_literal: true

module ErrorResponse
  class RequestError < StandardError
    attr_reader :key, :error_message, :error_data

    def initialize(key, error_message: nil, error_data: {})
      @key = key
      @error_message = error_message
      @error_data = error_data
    end
  end
end
