# frozen_string_literal: true

require 'json'
require 'fileutils'

module GitlabCodeReviewer
  class Erblint
    def initialize(file:, format: 'MESSAGE')
      @file = File.read(file)
      @format = format
      @reports = JSON.parse(@file)
      @data = @reports['files'].select { |report| report['offenses'].size > 0 }
    end

    def call
      return 'No offense found!' if @data.size.zero?

      commit_sha_hash = fetch_latest_mr_version

      @data.each do |report_hash|
        filepath = report_hash['path']
        offenses = report_hash['offenses']

        offenses.each do |offense_hash|
          ::GitlabCodeReviewer::Util::ThreadPoster.new(
            filepath: filepath,
            line_number: offense_hash['location']['start_line'],
            message: draft_a_thread_message(offense_hash),
            commit_sha_hash: commit_sha_hash
          ).call
        end
      end
    end

    private

    # Variables:
    #  * LINTER - linter name
    #  * MESSAGE - error message
    #  * LINE_NUMBER - line number of the offense
    def draft_a_thread_message(offense_hash)
      linter_name = offense_hash['linter']
      linter_message = offense_hash['message']
      line_number = offense_hash['location']['start_line']

      message = @format.gsub(/LINTER/, linter_name)
      message = message.gsub(/MESSAGE/, linter_message)
      message = message.gsub(/LINE_NUMBER/, line_number.to_s)
      message
    end

    def fetch_latest_mr_version
      ::GitlabCodeReviewer::Util::LatestMrVersionFetcher.call
    end
  end
end
