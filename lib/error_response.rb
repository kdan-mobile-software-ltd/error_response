require 'yaml'
require 'open-uri'

class ErrorResponse
  YAML_PATHS = 'config/error_*.yml'

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

  def self.load_remote(urls)
    if urls.is_a? Array
      @hash = urls.map { |url| build_yaml(url) }.inject(&:merge)
    else
      @hash = build_yaml(urls)
    end
  end

  private

  def self.yaml_hash
    return @hash unless @hash.nil?

    files = Dir[YAML_PATHS]
    @hash = files.map { |file| YAML.load_file(file) }.inject(&:merge)
  end

  def self.build_yaml(url)
    content = open(url){|f| f.read}
    YAML.load(content)
  end
end
