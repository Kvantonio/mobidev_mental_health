require 'rails_helper'

RSpec.describe LoginUserController, type: :controller do
  describe "GET #new" do
    it "check login status [user login page]" do
      get :new
      expect(response).to have_http_status(:ok)
    end
    it "render template login [user login page]" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "responds to #create" do
    it "check login redirect to dashboard [user login page]" do
      user = create :user
      post :create, params: { email: user.email, password: user.password }
      expect(subject).to redirect_to '/user/dashboard'
    end
  end
end
