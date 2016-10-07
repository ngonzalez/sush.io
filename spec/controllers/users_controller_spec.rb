require "rails_helper"

RSpec.describe UsersController, :type => :controller do
  describe "GET #index" do
    context "with user" do
      setup do
        @user = FactoryGirl.create :user
      end

      it "responds successfully with an HTTP 200 status code" do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
        assert assigns(:users).include?(@user)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
  end
end