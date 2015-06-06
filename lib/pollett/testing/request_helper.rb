module Pollett
  module Testing
    module RequestHelper
      module ClassMethods
        def it_requires_authentication(method, path)
          it "requires authentication" do
            begin
              json_request(method, path)
              expect_status(401)
            rescue Pollett::Unauthorized
            end
          end
        end
      end

      module InstanceMethods
        def json
          @json ||= JSON.parse(response.body, symbolize_names: true)
        end

        def data
          @data ||= json[:data]
        end

        def errors
          @errors ||= json[:errors]
        end

        def meta
          @meta ||= json[:meta]
        end

        def expect_status(status)
          expect(response.status).to eq(status)
        end

        def expect_keys(hash, *keys)
          keys.each { |k| expect(hash).to have_key(k) }
        end

        def a_head(path, context, params = nil)
          authenticated_request(:head, path, context, params)
        end

        def a_get(path, context, params = nil)
          authenticated_request(:get, path, context, params)
        end

        def a_post(path, context, params = nil)
          authenticated_request(:post, path, context, params)
        end

        def a_patch(path, context, params = nil)
          authenticated_request(:patch, path, context, params)
        end

        def a_put(path, context, params = nil)
          authenticated_request(:put, path, context, params)
        end

        def a_delete(path, context, params = nil)
          authenticated_request(:delete, path, context, params)
        end

        def authenticated_request(method, path, context, params)
          json_request(method, path, params, auth_header_for(context))
        end

        def json_request(method, path, params = nil, headers = {})
          send(method, path, params_for(method, params), headers.merge({
            "CONTENT_TYPE" => "application/json"
          }))
        end

        def params_for(method, params)
          if [:post, :patch, :put].include?(method) && params
            JSON.generate(params)
          else
            params
          end
        end

        def auth_header_for(context)
          { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Token.encode_credentials(context.id) }
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
