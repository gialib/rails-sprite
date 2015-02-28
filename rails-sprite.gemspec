$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_sprite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-sprite"
  s.version     = RailsSprite::VERSION
  s.authors     = ["WangJinzhong"]
  s.email       = ["andywang7259@163.com"]
  s.homepage    = "http://github.com"
  s.summary     = "Summary of RailsSprite."
  s.description = "Description of RailsSprite."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency 'rmagick'

  s.add_development_dependency "sqlite3"
end
