Gem::Specification.new do |s|
  s.name        = 'mina-extras'
  s.version     = '0.0.6'
  s.date        = '2013-11-08'
  s.summary     = "extra mina deploy tasks"
  s.description = "Provides extra Mina deploy tasks for Puma, RVM, Faye."
  s.authors     = ["Jan Berdajs"]
  s.email       = 'mrbrdo@gmail.com'
  s.files       = Dir["lib/mina-extras/*.rb"]
  s.homepage    = 'https://github.com/mrbrdo/mina-extras'
  s.license     = 'MIT'

  s.add_dependency 'mina'
end
