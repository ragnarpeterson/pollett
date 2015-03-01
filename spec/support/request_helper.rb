module RequestHelper
  module ClassMethods
    def it_requires_authentication(method, path)
      it "requires authentication" do
        json_request(method, path)
        expect_status(401)
      end
    end
  end

  module InstanceMethods
    def json
      @json ||= JSON.parse(response.body, symbolize_names: true)
    end

    def expect_status(status)
      expect(response.status).to eq(status)
    end

    def a_head(path, session, params = nil)
      authenticated_request(:head, path, session, params)
    end

    def a_get(path, session, params = nil)
      authenticated_request(:get, path, session, params)
    end

    def a_post(path, session, params = nil)
      authenticated_request(:post, path, session, params)
    end

    def a_put(path, session, params = nil)
      authenticated_request(:put, path, session, params)
    end

    def a_delete(path, session, params = nil)
      authenticated_request(:delete, path, session, params)
    end

    def authenticated_request(method, path, session, params)
      json_request(method, path, params, auth_header_for(session))
    end

    def json_request(method, path, params = nil, headers = {})
      send(method, path, params_for(method, params), headers.merge({
        "CONTENT_TYPE" => "application/json"
      }))
    end

    def params_for(method, params)
      if [:post, :put].include?(method) && params
        JSON.generate(params)
      else
        params
      end
    end

    def auth_header_for(session)
      { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Token.encode_credentials(session.token) }
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
