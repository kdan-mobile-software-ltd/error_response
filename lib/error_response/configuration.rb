# frozen_string_literal: true

module ErrorResponse
  class Configuration
    attr_accessor :yaml_config_path, :error_message_resolver

    def initialize
      @yaml_config_path = ENV["YAML_CONFIG_PATH"] || "config/error_response.yml"
      @error_message_resolver = nil
    end
  end
end
