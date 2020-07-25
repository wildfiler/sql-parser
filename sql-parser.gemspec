$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'sql-parser/version'

Gem::Specification.new do |s|
  s.name        = 'sql-parser'
  s.version     = "#{SQLParser::VERSION}.#{ENV['BUILD_NUMBER'] || `hostname`.strip}"
  s.authors     = ['Dray Lacy', 'Louis Mullie']
  s.email       = %w[dray@izea.com louis.mullie@gmail.com]
  s.homepage    = 'https://github.com/louismullie/sql-parser'
  s.summary     = ' Ruby library for parsing and generating SQL statements '
  s.description = ' A Racc-based Ruby parser and generator for SQL statements '

  s.files = Dir.glob('lib/**/*')

  s.add_runtime_dependency 'racc'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rexical'
  s.add_development_dependency 'test-unit'
end
