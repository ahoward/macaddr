## macaddr.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "macaddr"
  spec.version = "1.2.1"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "macaddr"
  spec.description = "description: macaddr kicks the ass"

  spec.files =
["LICENSE", "README", "Rakefile", "lib", "lib/macaddr.rb", "macaddr.gemspec"]

  spec.executables = []
  
  spec.require_path = "lib"

  spec.test_files = nil

### spec.add_dependency 'lib', '>= version'
#### spec.add_dependency 'map'
  spec.add_dependency('systemu', '~>2')

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/macaddr"
end
