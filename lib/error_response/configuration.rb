# frozen_string_literal: true

module ErrorResponse
  class Configuration

    attr_accessor :yaml_config_path

    def initialize
      @yaml_config_path = ENV['YAML_CONFIG_PATH'] || 'config/error_response.yml'
    end
  end
end
