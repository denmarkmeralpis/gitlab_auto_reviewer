# frozen_string_literal: true

require 'json'
require 'fileutils'

module GitlabCodeReviewer
  class Rubocop
    def initialize(file:, format: default_message_format)
      @file = File.read(file)
      @reports = JSON.parse(@file)
      @format = default_message_format
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
            line_number: offense_hash['location']['line'],
            message: draft_a_thread_message(offense_hash),
            commit_sha_hash: commit_sha_hash
          ).call
        end
      end
    end

    private

    # Variables:
    #  * COP_NAME - lint name
    #  * COP_MESSAGE - error message
    #  * LINE_NUMBER - line number of the offense
    def default_message_format
      'COP_NAME: COP_MESSAGE'
    end

    def draft_a_thread_message(offense_hash)
      cop_name = offense_hash['cop_name']
      cop_error = offense_hash['message']
      line_number = offense_hash['location']['line']

      @format.gsub(/COP_NAME/, cop_name)
      @format.gsub(/COP_MESSAGE/, cop_error)
      @format.gsub(/LINE_NUMBER/, line_number.to_s)
    end

    def fetch_latest_mr_version
      ::GitlabCodeReviewer::Util::LatestMrVersionFetcher.call
    end
  end
end
