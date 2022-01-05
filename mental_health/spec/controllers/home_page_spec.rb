require 'rails_helper'

RSpec.describe HomePageController, type: :controller do
  describe "GET #show" do
    it "render template show [home page]" do
      get :show
      expect(response).to render_template("show")
    end
  end
end
