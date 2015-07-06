require "rails_helper"

describe "Keys" do
  let!(:user) { create(:user, email: "john@example.com", password: "password") }
  let!(:session) { create(:pollett_session, user: user) }
  let!(:active) { create(:pollett_key, user: user, client: "active") }

  describe "GET /keys" do
    let!(:inactive) { create(:pollett_key, user: user, revoked_at: 1.day.ago, client: "inactive") }

    it_requires_authentication(:get, "/keys")

    it "responds with all active keys" do
      a_get("/keys", session)

      expect(data.map { |k| k[:id] }).to eq([active.id])
      expect_status(200)
    end
  end

  describe "POST /keys" do
    it_requires_authentication(:post, "/keys")

    context "with valid params" do
      let(:params) { { client: "fake" } }

      it "responds with new key" do
        a_post("/keys", session, params)

        expect(data[:relationships][:user][:data][:id]).to eq(user.id)
        expect(data[:attributes][:client]).to eq("fake")
        expect_status(201)
      end
    end

    context "with invalid params" do
      let(:params) { { } }

      it "raises an invalid record error" do
        expect do
          a_post("/keys", session, params)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "GET /keys/:id" do
    it_requires_authentication(:get, "/keys/1")

    it "responds with the specified key" do
      a_get("/keys/#{active.id}", session)

      expect(data[:id]).to eq(active.id)
      expect_status(200)
    end
  end

  describe "DELETE /keys/:id" do
    it_requires_authentication(:delete, "/keys/:id")

    it "responds with nothing" do
      a_delete("/keys/#{active.id}", session)

      expect_status(204)
    end
  end
end
