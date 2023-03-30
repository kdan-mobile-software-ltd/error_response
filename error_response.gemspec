Gem::Specification.new do |s|
  s.name        = 'error_response'
  s.version     = File.read("./VERSION.md")
  s.date        = Time.now.strftime('%F')
  s.summary     = "A tool for API error response"
  s.description = "use for error_response"
  s.authors     = ["Kdan Mobile Software Developer"]
  s.email       = 'dev@kdanmobile.com'
  s.homepage    = 'https://github.com/kdan-mobile-software-ltd/error_response'
  s.license     = 'MIT'
  s.files       = Dir["lib/**/*"]
  s.require_path     = ["lib"]
  s.required_ruby_version = '>= 2.7'
  s.metadata = {
    "source_code_uri" => "https://github.com/kdan-mobile-software-ltd/error_response",
    "changelog_uri" => "https://github.com/kdan-mobile-software-ltd/error_response/blob/master/CHANGELOG.md"
  }

  s.add_development_dependency 'activesupport', '~> 6.1.7.3'
end
