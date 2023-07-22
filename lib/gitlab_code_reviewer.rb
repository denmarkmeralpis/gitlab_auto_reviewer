# frozen_string_literal: true

require_relative 'gitlab_code_reviewer/version'
require_relative 'gitlab_code_reviewer/util/latest_mr_fetcher'
require_relative 'gitlab_code_reviewer/util/thread_poster'
require_relative 'gitlab_code_reviewer/rubocop'

module GitlabCodeReviewer
  class Error < StandardError; end
  # Your code goes here...
end
