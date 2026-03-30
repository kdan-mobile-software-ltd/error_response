# frozen_string_literal: true

require "yaml"
require "net/http"
require "uri"

require "error_response/configuration"
require "error_response/helper"
require "error_response/request_error"

module ErrorResponse
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def all
      yaml_hash
    end

    def to_hash(key)
      return {} unless yaml_hash.key?(key.to_s)

      yaml_hash[key.to_s].merge({ "error_key" => key.to_s })
    end

    def to_api(key, message = nil)
      json = deep_dup(yaml_hash)
      json = json[key.to_s] || { "error_code" => 500_000, "error_message" => key.to_s }
      json["error_key"] = key.to_s
      json["error_message"] += ": #{message}" unless message.nil?
      {
        status: parse_status(json["error_code"]),
        json: json
      }
    end

    private

    def yaml_hash
      return @hash unless @hash.nil?

      settings = YAML.safe_load_file(configuration.yaml_config_path, permitted_classes: permitted_classes, aliases: true)
      local_array = settings["source"]["local"]
      local_hash = local_array.nil? ? {} : local_array.map { |path| YAML.safe_load_file(path, permitted_classes: permitted_classes, aliases: true) }.inject(&:merge)

      remote_array = settings["source"]["remote"]
      remote_hash = remote_array.nil? ? {} : remote_array.map { |url| build_yaml(url) }.inject(&:merge)

      @hash = local_hash.merge(remote_hash)
    end

    def build_yaml(url)
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)
      response.value
      content = response.body
      YAML.safe_load(content, permitted_classes: permitted_classes, aliases: true)
    rescue StandardError
      puts "Load yaml from URL (#{url}) failed."
      {}
    end

    def parse_status(error_code)
      error_code.to_s[0..2].to_i
    end

    def deep_dup(hash)
      hash.to_h do |key, value|
        [
          key,
          if value.is_a?(Hash)
            deep_dup(value)
          else
            begin
              value.dup
            rescue StandardError
              value
            end
          end
        ]
      end
    end

    def permitted_classes
      [
        Date,
        Time,
        Symbol,
        Integer,
        Float,
        String,
        TrueClass,
        FalseClass,
        NilClass
      ]
    end
  end
end
