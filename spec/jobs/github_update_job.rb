require "rails_helper"

RSpec.describe GithubUpdateJob, :type => :job do
  describe "Perform Update" do
    context "with user and old repo" do
      setup do
        @user = FactoryGirl.create :user, name: "ngonzalez"
        @repository = FactoryGirl.create :repository, user: @user
      end
      it "responds successfully with an HTTP 200 status code" do
        # Stub GitHub API Responses
        allow_any_instance_of(Octokit::Configurable).to receive(:login).and_return(true)
        stub_request(:get, "https://api.github.com/user").to_return(status: 200, body: File.read(Rails.root.join("spec/web_mocks/github_user")), headers: {'Content-Type' => 'application/json'})
        stub_request(:get, "https://api.github.com/users/#{@user.name}/repos?page=1&per_page=#{API_PER_PAGE}").to_return(status: 200, body: File.read(Rails.root.join("spec/web_mocks/github_repos")), headers: {'Content-Type' => 'application/json'})
        stub_request(:get, "https://api.github.com/users/#{@user.name}/starred?page=1&per_page=#{API_PER_PAGE}").to_return(status: 200, body: File.read(Rails.root.join("spec/web_mocks/github_starred")), headers: {'Content-Type' => 'application/json'})

        # Old repo will be deleted
        assert_equal [@repository.name], @user.repositories.map(&:name)

        # Run Job
        GithubUpdateJob.perform_now user: @user

        # Results should match the web mock templates
        assert_equal ["js-multi-upload", "sound.js"], @user.starred_repositories.map(&:name)
        assert @user.repositories.map(&:name).include?("sush.io")
      end
    end
  end
end