require 'yaml'
class ErrorResponse
  GEM_ROOT = File.expand_path("../..", __FILE__)
  YAML_PATH = 'lib/error_response.yml'

  def self.to_api(key, message=nil)
    err_json = yaml_hash[key.to_s] || {'error_code' => 500000, 'error_message' => message}

    status = err_json['error_code'] / 1000
    {
      'status' => status,
      'json' => err_json
    }
  end

  def self.to_hash(key)
    yaml_hash[key.to_s]
  end

  def self.all
    yaml_hash
  end

  private
  def self.yaml_hash
    yaml ||= YAML.load_file(File.join(GEM_ROOT,YAML_PATH))
  end
end