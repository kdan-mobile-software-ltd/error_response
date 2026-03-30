# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "error_response"
  s.version     = File.read("./VERSION.md")
  s.summary     = "A tool for API error response"
  s.description = "use for error_response"
  s.authors     = ["Kdan Mobile Software Developer"]
  s.email       = "dev@kdanmobile.com"
  s.homepage    = "https://github.com/kdan-mobile-software-ltd/error_response"
  s.license     = "MIT"
  s.files       = Dir["lib/**/*"]
  s.require_path = ["lib"]
  s.required_ruby_version = ">= 3.0"
  s.metadata = {
    "source_code_uri" => "https://github.com/kdan-mobile-software-ltd/error_response",
    "changelog_uri" => "https://github.com/kdan-mobile-software-ltd/error_response/blob/master/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  s.add_dependency "activesupport", "~> 7.2.3.1"
end
