require 'yaml'
class ErrorResponse
  GEM_ROOT = File.expand_path("../..", __FILE__)
  YAML_PATH = 'lib/error_response.yml'

  def self.call(key, message=nil)
    string_hash = YAML.load_file(File.join(GEM_ROOT,YAML_PATH))
    err_json = string_hash[key.to_s] || {'error_code' => 500000, 'error_message' => message}

    status = err_json['error_code'] / 1000
    {
      'status' => status,
      'json' => err_json
    }
  end
end