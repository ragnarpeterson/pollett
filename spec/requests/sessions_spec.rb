require "spec_helper"

describe "Sessions" do
  let!(:user) { create(:user, email: "john@example.com", password: "password") }
  let!(:session) { create(:session, user: user) }

  describe "GET /sessions/current" do
    it_requires_authentication(:get, "/sessions/current")

    context "when session is active" do
      it "responds with the current session" do
        a_get("/sessions/current", session)

        expect(json[:session][:id]).to eq(session.id)
        expect_status(200)
      end
    end

    context "when session has been revoked" do
      before { session.revoke! }

      it "responds with unauthorized" do
        a_get("/sessions/current", session)

        expect_status(401)
      end
    end

    context "when session has timed out" do
      before { session.update!(accessed_at: 3.weeks.ago) }

      it "responds with unauthorized" do
        a_get("/sessions/current", session)

        expect_status(401)
      end
    end
  end

  describe "POST /sessions" do
    context "when logging in" do
      let(:params) { { email: "john@example.com", password: "password" } }

      context "with valid credentials" do
        it "responds with new session" do
          json_request(:post, "/sessions", params)

          expect(json[:session][:user][:id]).to eq(user.id)
          expect_status(201)
        end
      end

      context "with invalid credentials" do
        before { params[:password] = "wrong" }

        it "responds with unauthorized" do
          json_request(:post, "/sessions", params)

          expect_status(401)
        end
      end
    end

    context "when registering" do
      let(:params) { { name: "New User", email: "new@example.com", password: "password", method: "register" } }

      context "with valid params" do
        it "responds with new session" do
          json_request(:post, "/sessions", params)

          expect(json[:session][:user][:name]).to eq("New User")
          expect(json[:session][:user][:email]).to eq("new@example.com")
          expect_status(201)
        end

        it "sends a welcome email" do
          json_request(:post, "/sessions", params)

          expect(last_email).to be_present
          expect(last_email.to).to include("new@example.com")
        end

        context "and config.send_welcome_email set to false" do
          before { Pollett.config.send_welcome_email = false }

          it "does not send a welcome email" do
            json_request(:post, "/sessions", params)

            expect(last_email).to be_nil
          end
        end
      end

      context "with invalid params" do
        before { params.delete(:email) }

        it "raises an invalid record error" do
          expect do
            json_request(:post, "/sessions", params)
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context "when resetting password" do
      before { user.update!(reset_token: Pollett.generate_token) }

      let(:params) { { token: user.reset_token, password: "password", method: "reset" } }

      context "with valid params" do
        it "responds with new session" do
          json_request(:post, "/sessions", params)

          expect(json[:session][:user][:id]).to eq(user.id)
          expect_status(201)
        end
      end

      context "with invalid password" do
        before { params[:password] = "wrong" }

        it "raises an invalid record error" do
          expect do
            json_request(:post, "/sessions", params)
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "with invalid reset_token" do
        before { params[:token] = "wrong" }

        it "raises a record not found error" do
          expect do
            json_request(:post, "/sessions", params)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "POST /sessions/forgot" do
    context "when email is valid" do
      let(:params) { { email: "john@example.com" } }

      it "is accepted" do
        json_request(:post, "/sessions/forgot", params)

        expect_status(202)
      end

      it "sends an email" do
        json_request(:post, "/sessions/forgot", params)

        expect(last_email).to be_present
        expect(last_email.to).to include("john@example.com")
        expect(last_email.body.to_s).to match(/\w+\/reset/)
      end
    end

    context "when email is invalid" do
      let(:params) { { email: "wrong@example.com" } }

      it "is accepted" do
        json_request(:post, "/sessions/forgot", params)

        expect_status(202)
      end

      it "does not send an email" do
        json_request(:post, "/sessions/forgot", params)

        expect(last_email).to be_nil
      end
    end
  end

  describe "DELETE /sessions/current" do
    it_requires_authentication(:delete, "/sessions/current")

    it "responds with nothing" do
      a_delete("/sessions/current", session)

      expect_status(204)
    end
  end
end
