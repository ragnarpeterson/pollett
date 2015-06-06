require "rails_helper"

describe "User" do
  let!(:user) { create(:user, email: "john@example.com", password: "password") }
  let!(:session) { create(:pollett_session, user: user) }

  describe "GET /user" do
    it_requires_authentication(:get, "/user")

    it "responds with the authenticated user" do
      a_get("/user", session)

      expect(data[:id]).to eq(user.id)
      expect_status(200)
    end
  end

  describe "PATCH /user" do
    let(:params) { { email: "new@example.com" } }

    it_requires_authentication(:patch, "/user")

    it "responds with the updated user" do
      a_patch("/user", session, params)

      expect(data[:id]).to eq(user.id)
      expect(data[:email]).to eq(params[:email])
      expect_status(200)
    end
  end

  describe "DELETE /user" do
    it_requires_authentication(:delete, "/user")

    it "responds with nothing" do
      a_delete("/user", session)

      expect_status(204)
    end
  end
end
