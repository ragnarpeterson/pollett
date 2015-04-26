require "email_validator"

module Pollett
  module User
    extend ActiveSupport::Concern

    included do
      has_secure_password

      has_many :contexts, class_name: "Pollett::Context"
      has_many :sessions, class_name: "Pollett::Session"
      has_many :keys, class_name: "Pollett::Key"

      before_validation :normalize_email

      validates :name, presence: true

      validates :email, presence: true,
                        uniqueness: true,
                        email: { strict_mode: true }

      validates :password, length: { minimum: Pollett.config.minimum_password_length }, if: :password
    end

    module ClassMethods
      def find_by_normalized_email(email)
        find_by(email: normalize_email(email))
      end

      def normalize_email(email)
        email.to_s.downcase.gsub(/\s+/, "")
      end
    end

    private
    def normalize_email
      self.email = self.class.normalize_email(email)
    end
  end
end
