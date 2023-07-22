require 'spec_helper'
require 'webmock/rspec'

module GitlabCodeReviewer
  module Util
    RSpec.describe LatestMrVersionFetcher do
      before do
        stub_const 'ENV', ENV.to_h.merge(
          'CI_API_V4_URL' => 'https://gitlab.example.com/api/v4',
          'CI_PROJECT_ID' => 1,
          'CI_MERGE_REQUEST_IID' => 1,
          'SERVICE_ACCOUNT_ACCESS_TOKEN' => 'very-secured-token'
        )
      end

      describe '#call' do
        before do
          stub_request(:get, 'https://gitlab.example.com/api/v4/projects/1/merge_requests/1/versions').with(
            headers: { 'PRIVATE-TOKEN' => 'very-secured-token' }
          ).to_return(status: 200, body: [{ key: 'val' }].to_json)
        end

        it 'returns a hash' do
          expect(described_class.call).to be_a(Hash)
        end
      end
    end
  end
end
