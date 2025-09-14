require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      get "/signup"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users" do
    it "creates a user with valid params" do
      user_params = {
        user: {
          email_address: 'test@example.com',
          username: 'testuser',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      expect {
        post "/users", params: user_params
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end
  end
end
