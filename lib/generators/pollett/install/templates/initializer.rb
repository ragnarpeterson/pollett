Pollett.configure do |config|
  config.reset_url = ->(token) { "https://example.com/#{token}/reset" }
end
