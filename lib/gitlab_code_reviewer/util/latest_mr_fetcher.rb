# frozen_string_literal: true

require 'uri'
require 'net/http'

module GitlabCodeReviewer
  module Util
    class LatestMrVersionFetcher
      API_ENDPOINT = 'CI_API_V4_URL/projects/CI_PROJECT_ID/merge_requests/CI_MERGE_REQUEST_IID/versions'

      def initialize(options = {})
        @url = API_ENDPOINT.gsub(/CI_API_V4_URL/, ENV['CI_API_V4_URL'])
        @url = @url.gsub(/CI_PROJECT_ID/, ENV['CI_PROJECT_ID'].to_s)
        @url = @url.gsub(/CI_MERGE_REQUEST_IID/, ENV['CI_MERGE_REQUEST_IID'].to_s)
      end

      def call
        uri = URI.parse(@url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        headers = { 'PRIVATE-TOKEN' => ENV['SERVICE_ACCOUNT_ACCESS_TOKEN'] }
        request = Net::HTTP::Get.new(uri.path, headers)
        response = http.request(request)

        data = JSON.parse(response.body)
        data.first
      end

      def self.call(options = {})
        new(options).call
      end
    end
  end
end
