# frozen_string_literal: true

require_relative 'lib/gitlab_code_reviewer/version'

Gem::Specification.new do |spec|
  spec.name = 'gitlab_code_reviewer'
  spec.version = GitlabCodeReviewer::VERSION
  spec.authors = ['Nujian Den Mark Meralpis']
  spec.email = ['denmarkmeralpis@gmail.com']
  spec.summary = 'Automated RubyGem for GitLab discussions on code offenses, streamlining reviews with essential details. Simplify and enhance code collaboration.'
  spec.description = 'Introducing a RubyGem that automates GitLab discussions for code offenses, saving time during reviews. It provides crucial details like line numbers and cop messages, streamlining the process for reviewers and fostering better collaboration. Simplify code reviews with this powerful addition to GitLab projects!'
  spec.homepage = 'https://github.com/denmarkmeralpis/gitlab_code_reviewer'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['allowed_push_host'] = 'https://github.com/denmarkmeralpis/gitlab_code_reviewer'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/denmarkmeralpis/gitlab_code_reviewer'
  spec.metadata["changelog_uri"] = 'https://github.com/denmarkmeralpis/gitlab_code_reviewer/changelog'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
