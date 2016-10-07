require "rails_helper"

RSpec.describe GithubController, :type => :controller do
  describe "GET #index" do
    context "with repositories" do
      setup do
        @user = FactoryGirl.create :user
        10.times do
          @user.repositories << FactoryGirl.create(:repository)
        end
      end

      it "responds successfully with an HTTP 200 status code" do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
  end
end