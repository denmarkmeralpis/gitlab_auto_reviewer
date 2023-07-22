require 'spec_helper'
require 'webmock/rspec'

module GitlabCodeReviewer
  module Util
    RSpec.describe ThreadPoster do
      before do
        stub_const 'ENV', ENV.to_h.merge(
          'CI_API_V4_URL' => 'https://gitlab.example.com/api/v4',
          'CI_PROJECT_ID' => 1,
          'CI_MERGE_REQUEST_IID' => 1,
          'SERVICE_ACCOUNT_ACCESS_TOKEN' => 'very-secured-token'
        )
      end

      describe '#call' do
        let(:app) do
          described_class.new(
            filepath: 'app/models/user.rb',
            message: 'FrozenString/Literals: Something something',
            line_number: 12,
            commit_sha_hash: {
              'base_commit_sha' => 'sha1',
              'head_commit_sha' => 'sha1',
              'start_commit_sha' => 'sha1',
            }
          )
        end

        before do
          stub_request(:post, 'https://gitlab.example.com/api/v4/projects/1/merge_requests/1/discussions').with(
            body: {
              body: 'FrozenString/Literals: Something something',
              position: {
                position_type: 'text',
                base_sha: 'sha1',
                head_sha: 'sha1',
                start_sha: 'sha1',
                new_path: 'app/models/user.rb',
                old_path: 'app/models/user.rb',
                new_line: 12
              }
            },
            headers: {
              'PRIVATE-TOKEN' => 'very-secured-token'
            }
          ).and_return(status: 200, body: { success: true }.to_json)
        end

        it { expect(app.call).to be_truthy }
      end
    end
  end
end
