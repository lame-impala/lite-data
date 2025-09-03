# frozen_string_literal: true

require_relative 'lib/lite/data/version'

Gem::Specification.new do |spec|
  spec.name = 'lite-data'
  spec.version = Lite::Data::Version::VERSION
  spec.authors = ['Tomas Milsimer']
  spec.email = ['tomas.milsimer@protonmail.com']

  spec.summary = 'Minimalistic data-class definition'
  spec.description = <<~DESC
    Easy definition of data classes with subclassing support
    and flexible constructor signatures.
  DESC
  spec.homepage = 'https://github.com/lame-impala/lite-data'

  spec.required_ruby_version = '>= 3.0.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ['lib']
  spec.licenses = ['MIT']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
