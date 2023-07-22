# frozen_string_literal: true

require 'uri'
require 'net/http'

module GitlabCodeReviewer
  module Util
    class LatestMrVersionFetcher
      GLAB_API_URL = 'CI_API_V4_URL/projects/CI_PROJECT_ID/merge_requests/CI_MERGE_REQUEST_IID/versions'

      def initialize(options = {})
        @access_token = options.fetch(:access_token, ENV['SERVICE_ACCOUNT_ACCESS_TOKEN'])
        @ci_api_v4_url = options.fetch(:ci_api_v4_url, ENV['CI_API_V4_URL'])
        @ci_project_id = options.fetch(:ci_project_id, ENV['CI_PROJECT_ID'])
        @ci_mr_iid = options.fetch(:ci_mr_iid, ENV['CI_MERGE_REQUEST_IID'])
        @url = GLAB_API_URL.gsub(/CI_API_V4_URL/, @ci_api_v4_url)
        @url = @url.gsub(/CI_PROJECT_ID/, @ci_project_id)
        @url = @url.gsub(/CI_MERGE_REQUEST_IID/, @ci_mr_iid)
      end

      def call
        uri = URI.parse(url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        headers = { 'PRIVATE-TOKEN' => @access_token }
        request = Net::HTTP::Get.new(uri.path, headers)
        response = http.request(request)

        data = JSON.parse(response.body)
        data.first
      end
    end
  end
end
