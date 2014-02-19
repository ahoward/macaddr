## macaddr.gemspec
#

Gem::Specification::new do |spec|
  spec.name              = "macaddr"
  spec.version           = "1.6.2"
  spec.platform          = Gem::Platform::RUBY
  spec.summary           = "macaddr"
  spec.description       = "cross platform mac address determination for ruby"
  spec.license           = "same as ruby's"

  spec.files =
  [ "Gemfile",
    "LICENSE",
    "README",
    "Rakefile",
    "lib",
    "lib/macaddr.rb",
    "macaddr.gemspec",
    "rvmrc.example",
    "test",
    "test/data",
    "test/data/noifconfig",
    "test/data/osx",
    "test/mac_test.rb",
    "test/testing.rb" ]

  spec.executables        = []
  spec.require_path       = "lib"
  spec.test_files         = nil

  spec.add_runtime_dependency "systemu", "~> 2.5.2"
  # spec.add_runtime_dependency "systemu", "~> 2.6.2"

  ##
  # spec.add_dependency 'lib', '>= version'
  # spec.add_dependency 'map'

  spec.extensions.push(*[])

  spec.rubyforge_project  = "codeforpeople"
  spec.author             = "Ara T. Howard"
  spec.email              = "ara.t.howard@gmail.com"
  spec.homepage           = "https://github.com/ahoward/macaddr"
end