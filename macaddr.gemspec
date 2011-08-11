require File.expand_path('../lib/mac/version', __FILE__)

Gem::Specification::new do |spec|
  spec.name        = "macaddr"
  spec.version     = Mac::VERSION
  spec.platform    = Gem::Platform::RUBY

  spec.author      = "Ara T. Howard"
  spec.email       = "ara.t.howard@gmail.com"
  spec.homepage    = "https://github.com/ahoward/macaddr"
  spec.summary     = "Retrieve MAC addresses."
  spec.description = "Retrieve all system MAC addresses across multiple platforms."

  spec.rubyforge_project = "codeforpeople"

  spec.add_dependency 'systemu', '>= 2.2.0'

  spec.files        = `git ls-files`.split("\n")
  spec.test_files   = nil
  spec.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  spec.require_path = 'lib'
end
