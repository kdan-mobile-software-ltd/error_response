Gem::Specification.new do |s|
  s.name        = 'error_response'
  s.version     = '0.0.4'
  s.date        = '2019-08-12'
  s.summary     = "A tool for API error response"
  s.description = "use for error_response"
  s.authors     = ["jameslee"]
  s.email       = 'jameslee@kdanmobile.com'
  s.files       = ["lib/error_response.rb"]
  s.homepage    = 'https://github.com/kdan-mobile-software-ltd/error_response'
  s.license       = 'MIT'

  s.files       = `git ls-files -- lib/*`.split("\n")
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options     = ['--charset=URF-8']
  s.require_path     = "lib"

  s.required_ruby_version = '>= 2.5.1'
end
