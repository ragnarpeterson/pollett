module Pollett
  class CreateSession
    include Servitore::Service

    param_reader :method

    def call
      user = service.call(params)
      user.sessions.create!
    end

    private
    def service
      @service ||= case method
      when "register" then RegisterUser
      when "reset" then ChangePassword
      else AuthenticateUser
      end
    end
  end
end
