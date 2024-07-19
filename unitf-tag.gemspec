# frozen_string_literal: true

require_relative 'lib/unitf/tag/version'

Gem::Specification.new do |spec|
  spec.name          = 'unitf-tag'
  spec.version       = Unitf::Tag::VERSION
  spec.authors       = ['Matt Baron']
  spec.email         = ['mwb@unitf.net']

  spec.summary       = 'Audio File Tagging'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/mattbaron/unitf-tag'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://www.rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mattbaron/unitf-tag'
  spec.metadata['changelog_uri'] = 'https://github.com/mattbaron/unitf-tag/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'taglib-ruby'
  spec.add_dependency 'unitf-logging'
end
