# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'active_model_attributes/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_model_attributes'
  spec.version       = ActiveModelAttributes::VERSION
  spec.authors       = ['alpaca-tc']
  spec.email         = ['alpaca-tc@alpaca.tc']

  spec.summary       = %q{Backport ActiveModel::Attributes -like method}
  spec.homepage      = 'https://github.com/alpaca-tc/active_model_attributes'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 4.2.0', '< 5.2.0'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'appraisal'
end
