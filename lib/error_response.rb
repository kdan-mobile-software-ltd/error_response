require 'yaml'
require 'open-uri'

class ErrorResponse
  SETTING_PATH = 'config/error_response.yml'

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
    return @hash unless @hash.nil?

    settings = YAML.load(File.read(SETTING_PATH))
    local_hash = settings['source']['local'].map { |path| YAML.load_file(path) }.inject(&:merge)
    remote_hash = settings['source']['remote'].map { |url| build_yaml(url) }.inject(&:merge)
    
    @hash = local_hash.merge(remote_hash)
  end

  def self.build_yaml(url)
    content = open(url){|f| f.read}
    YAML.load(content)
  end
end
