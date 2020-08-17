Gem::Specification.new do |s|
  s.name        = 'error_response'
  s.version     = ENV['RELEASE_VERSION']
  s.date        = '2020-08-14'
  s.summary     = "A tool for API error response"
  s.description = "use for error_response"
  s.authors     = ["Kdan Mobile Software Developer"]
  s.email       = 'dev@kdanmobile.com'
  s.homepage    = 'https://github.com/kdan-mobile-software-ltd/error_response'
  s.license     = 'MIT'
  s.files       = Dir["lib/*"]
  s.require_path     = ["lib"]
  s.required_ruby_version = '>= 2.5.1'
end
