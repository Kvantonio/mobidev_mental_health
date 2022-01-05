require 'rails_helper'

RSpec.describe LoginCoachController, type: :controller do
  describe "GET #new" do
    it "check login status [coach login page]" do
      get :new
      expect(response).to have_http_status(:ok)
    end
    it "render template login [coach login page]" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "responds to #create" do
    it "check login redirect to dashboard [coach login page]" do
      coach = create :coach
      post :create, params: { email: coach.email, password: coach.password }
      expect(subject).to redirect_to '/coach/dashboard'
    end
  end
end
