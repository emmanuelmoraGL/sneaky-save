# frozen_string_literal: true

version = File.read(File.expand_path('VERSION', __dir__)).strip

Gem::Specification.new do |s|
  s.name = 'sneaky-save'
  s.version = version

  s.date = '2016-08-06'
  s.authors = ['Sergei Zinin (einzige)']
  s.email = 'szinin@gmail.com'
  s.homepage = 'http://github.com/einzige/sneaky-save'

  s.licenses = ['MIT']

  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.extra_rdoc_files = ['README.md']

  s.description = 'ActiveRecord extension. Allows to save record without calling callbacks and validations.'
  s.summary = 'Allows to save record without calling callbacks and validations.'

  s.add_runtime_dependency 'activerecord', '>= 6.0.0', '< 8.0'
  s.add_development_dependency 'rspec'
end
