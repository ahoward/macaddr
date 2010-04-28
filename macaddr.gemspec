## macaddr.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "macaddr"
  spec.version = "1.1.0"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "macaddr"
  spec.description = "description: macaddr kicks the ass"

  spec.files = ["lib", "lib/macaddr.rb", "macaddr.gemspec", "Rakefile", "README"]
  spec.executables = []
  
  spec.require_path = "lib"

  spec.has_rdoc = true
  spec.test_files = nil
  #spec.add_dependency 'lib', '>= version'
  spec.add_dependency 'systemu'

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "http://github.com/ahoward/macaddr/tree/master"
end
