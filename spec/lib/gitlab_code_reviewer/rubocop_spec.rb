require 'spec_helper'

module GitlabCodeReviewer
  RSpec.describe Rubocop do
    describe '#call' do
      context 'when no offense found' do
        let(:file) { File.expand_path('../../fixtures/rubocop/0.json', __dir__) }
        let(:app) { described_class.new(file: file) }

        it 'returns a message No offense found!' do
          expect(app.call).to eq('No offense found!')
        end
      end

      context 'when there is an offense found' do
        let(:file) { File.expand_path('../../fixtures/rubocop/1.json', __dir__) }
        let(:app) { described_class.new(file: file) }

        before do
          mr_fetcher = instance_double(GitlabCodeReviewer::Util::LatestMrVersionFetcher)
          thread_poster = instance_double(GitlabCodeReviewer::Util::ThreadPoster)

          allow(GitlabCodeReviewer::Util::LatestMrVersionFetcher).to receive(:new).and_return(mr_fetcher)
          allow(mr_fetcher).to receive(:call).and_return({ sha: 1 })
          allow(GitlabCodeReviewer::Util::ThreadPoster).to receive(:new).and_return(thread_poster)
          allow(thread_poster).to receive(:call).and_return(true)
        end

        it 'returns truthy value' do
          expect(app.call).to be_truthy
        end
      end
    end
  end
end
