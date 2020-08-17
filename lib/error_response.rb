require 'yaml'
class ErrorResponse
  YAML_PATH = 'config/error_response.yml'

  def self.to_api(key, message=nil)
    err_json = yaml_hash[key.to_s]&.dup
    err_json['error_key'] = key.to_s if !err_json.nil? && !key.nil? && yaml_hash.key?(key.to_s)
    if err_json.nil?
      err_json = {'error_code' => 500000, 'error_message' => message}
    elsif !message.nil?
      err_json['error_message'] += ": #{message}"
    end

    status = err_json['error_code'] / 1000
    {
      status: status,
      json: err_json
    }
  end

  def self.to_hash(key)
    if yaml_hash.key?(key.to_s)
      result = yaml_hash[key.to_s]
      result['error_key'] = key.to_s
    else
      result = nil
    end
    result
  end

  def self.all
    yaml_hash
  end

  private
  def self.yaml_hash
    @hash ||= YAML.load_file(YAML_PATH)
  end
end