require "rails_helper"

RSpec.describe GithubUpdateJob, :type => :job do
  describe "Perform Update" do
    context "with user" do
      setup do
        @user = FactoryGirl.create :user, name: "ngonzalez"
      end
      it "responds successfully with an HTTP 200 status code" do
        # Stub GitHub API Responses
        content = JSON.parse File.read(Rails.root.join("spec/web_mocks/github_repos"))
        response = content.each_with_object([]){ |item, array| array << item.deep_symbolize_keys }
        stub_request(:get, "https://api.github.com/users/#{@user.name}/repos?page=1&per_page=#{API_PER_PAGE}").to_return(status: 200, body: response)
        allow_any_instance_of(Octokit::Configurable).to receive(:login).and_return(true)
        content = JSON.parse File.read(Rails.root.join("spec/web_mocks/github_user"))
        response = content.deep_symbolize_keys
        stub_request(:get, "https://api.github.com/user").with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>"token #{GITHUB_TOKEN}", 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.3.0'}).to_return(status: 200, body: response.to_s)
        content = JSON.parse File.read(Rails.root.join("spec/web_mocks/github_starred"))
        response = content.each_with_object([]){ |item, array| array << item.deep_symbolize_keys }
        stub_request(:get, "https://api.github.com/users/#{@user.name}/starred?page=1&per_page=#{API_PER_PAGE}").to_return(status: 200, body: response)

        # Run Job
        GithubUpdateJob.perform_now user: @user

        # Results should match the web mock templates
        assert_equal ["js-multi-upload", "sound.js"], @user.starred_repositories.map(&:name)
        assert @user.repositories.map(&:name).include?("sush.io")
      end
    end
  end
end