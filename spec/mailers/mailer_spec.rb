require "rails_helper"

describe Pollett::Mailer do
  let!(:user) { create(:user, email: "john@example.com") }

  describe ".welcome" do
    let(:mail) { Pollett::Mailer.welcome(user) }

    it "sends email" do
      mail.deliver_now

      expect(last_email).to be_present
    end

    it "sets fields correctly" do
      email = mail.deliver_now

      expect(email[:from].decoded).to eq("from@example.com")
      expect(email[:to].decoded).to eq("john@example.com")
      expect(email.subject).to eq("Welcome!")
    end

    it "renders body correctly" do
      body = mail.deliver_now.body.to_s

      expect(body).to include("Welcome aboard!")
    end

    it "renders layout correctly" do
      body = mail.deliver_now.body.to_s

      expect(body).to include("Hi there")
      expect(body).to include("Pollett Team")
    end
  end

  describe ".reset" do
    before { user.update!(reset_token: Pollett.generate_token) }

    let(:mail) { Pollett::Mailer.reset(user) }

    it "sends email" do
      mail.deliver_now

      expect(last_email).to be_present
    end

    it "sets fields correctly" do
      email = mail.deliver_now

      expect(email[:from].decoded).to eq("from@example.com")
      expect(email[:to].decoded).to eq("john@example.com")
      expect(email.subject).to eq("Password Reset")
    end

    it "renders body correctly" do
      body = mail.deliver_now.body.to_s

      expect(body).to include("password change")
      expect(body).to include("/#{user.reset_token}/reset")
      expect(body).to include("ignore this email")
    end

    it "renders layout correctly" do
      body = mail.deliver_now.body.to_s

      expect(body).to include("Hi there")
      expect(body).to include("Pollett Team")
    end
  end
end
