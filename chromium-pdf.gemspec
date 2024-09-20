# frozen_string_literal: true

require_relative 'lib/chromium/pdf/version'

Gem::Specification.new do |spec|
  spec.name = 'chromium-pdf'
  spec.version = Chromium::Pdf::VERSION
  spec.authors = ['RoleModel Software']
  spec.email = ['it-support@rolemodelsoftware.com']

  spec.summary = "A wrapper around headless Chrome's print-to-pdf functionality."
  spec.homepage = 'https://github.com/RoleModel/chromium-pdf'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'
  spec.description = 'Add support for generating PDFs with chrome to a rails app'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/RoleModel/chromium-pdf'
  spec.metadata['changelog_uri'] = 'https://github.com/RoleModel/chromium-pdf/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
