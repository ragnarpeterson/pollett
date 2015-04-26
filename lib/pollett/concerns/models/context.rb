module Pollett
  module Concerns
    module Models
      module Context
        extend ActiveSupport::Concern

        included do
          belongs_to :user, class_name: Pollett.config.user_model_name

          before_create :set_token

          scope :active, -> { where("((type = 'Pollett::Session' AND accessed_at >= ?) OR (type = 'Pollett::Key')) AND revoked_at IS NULL", Pollett.config.timeout.ago) }
        end

        module ClassMethods
          def authenticate(token)
            active.find_by(token: token)
          end
        end

        def revoked
          revoked_at?
        end

        def active
          !revoked
        end

        def access(request)
          update({
            accessed_at: current_time_from_proper_timezone,
            ip: request.remote_ip,
            user_agent: request.user_agent
          })
        end

        def revoke!
          self.revoked_at ||= current_time_from_proper_timezone
          save!
        end

        private
        def set_token
          self.token = Pollett.generate_token
        end
      end
    end
  end
end