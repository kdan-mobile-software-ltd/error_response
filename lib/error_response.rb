require 'yaml'
class ErrorResponse
  YAML_PATH = 'config/error_response.yml'

  def self.all
    yaml_hash
  end

  def self.to_hash(key)
    return unless yaml_hash.key?(key.to_s)
    yaml_hash[key.to_s].merge({ 'error_key' => key.to_s })
  end

  def self.to_api(key, message=nil)
    default_result = {
      status: 500,
      json: { 'error_code' => 500_000, 'error_message' => message }
    }
    return default_result unless yaml_hash.key?(key.to_s)

    json = yaml_hash[key.to_s].merge({ 'error_key' => key.to_s })
    json['error_message'] += ": #{message}" unless message.nil?
    {
      status: json['error_code'] / 1_000,
      json: json
    }
  end

  private

  def self.yaml_hash
    @hash ||= YAML.load_file(YAML_PATH)
  end
end
