# frozen_string_literal: true

RSpec.describe GitlabCodeReviewer do
  it "has a version number" do
    expect(GitlabCodeReviewer::VERSION).not_to be nil
  end
end
