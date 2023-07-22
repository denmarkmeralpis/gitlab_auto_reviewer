# frozen_string_literal: true

require 'uri'
require 'net/http'

module GitlabCodeReviewer
  module Util
    class ThreadPoster
      API_ENDPOINT = 'CI_API_V4_URL/projects/CI_PROJECT_ID/merge_requests/CI_MERGE_REQUEST_IID/discussions'

      def initialize(options = {})
        @filepath = options.fetch(:filepath)
        @message = options.fetch(:message)
        @line_number = options.fetch(:line_number)
        @commit_sha_hash = options.fetch(:commit_sha_hash)
        @url = API_ENDPOINT.gsub(/CI_API_V4_URL/, ENV['CI_API_V4_URL'])
        @url = @url.gsub(/CI_PROJECT_ID/, ENV['CI_PROJECT_ID'].to_s)
        @url = @url.gsub(/CI_MERGE_REQUEST_IID/, ENV['CI_MERGE_REQUEST_IID'].to_s)
      end

      def call
        uri = URI.parse(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        headers = {
          'PRIVATE-TOKEN' => ENV['SERVICE_ACCOUNT_ACCESS_TOKEN']
        }

        params = {
          'position[position_type]' => 'text',
          'position[base_sha]' => @commit_sha_hash['base_commit_sha'],
          'position[head_sha]' => @commit_sha_hash['head_commit_sha'],
          'position[start_sha]' => @commit_sha_hash['start_commit_sha'],
          'position[new_path]' => @filepath,
          'position[old_path]' => @filepath,
          'position[new_line]' => @line_number,
          'body' => @message
        }

        request = Net::HTTP::Post.new(uri.path, headers)
        request.set_form_data(params)
        http.request(request)
      end
    end
  end
end
