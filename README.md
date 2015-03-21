# Pollett

Token-based authentication for your Rails API.

Pollett is a simple authentication library for your API-only Rails app. It treats sessions as a [first class domain concern]
(https://github.com/blog/1661-modeling-your-app-s-user-session) and takes its inspiration from [Clearance](https://github.com/thoughtbot/clearance).

Pollett currently requires Postgres and the use of UUID primary keys. This means you will need to have the `uuid-ossp` extension enabled before using Pollett.

## Install

To get started, add Pollett to your `Gemfile`, `bundle install`, and run the
`install generator`:

```sh
$ rails g pollett:install
```

The generator:

* Inserts `Pollett::User` into your `User` model
* Inserts `Pollett::Controller` into your `ApplicationController`
* Creates an initializer to allow further configuration
* Creates a migration that either creates a users table or adds the necessary columns to the existing table
* Copies over the Session model migration
* Mounts the engine

Then, just migrate the database:

```sh
$ rake db:migrate
```

## Configure

Override any of these defaults in `config/initializers/pollett.rb`:

```ruby
Pollett.configure do |config|
  config.user_model = ::User
  config.minimum_password_length = 8
  config.send_welcome_email = true
  config.parent_mailer = ::ApplicationMailer
  config.from_email = "noreply@example.com"
  config.reset_url = ->(token) { "https://example.com/#{token}/reset" }
  config.whitelist = []
end
```

At minimum, you will need to configure `reset_url` so that the link will be correct in password reset emails. Also, if a default "from" email is not set in your `parent_mailer`, you will need to configure `from_email` as well.

## Use

### Access Control

Pollett authentication is opt-out rather than opt-in. This means that if there is an action that does not require authentication, you will need to use `skip_authentication`:

```ruby
class ArticlesController < ApplicationController
  skip_authentication only: :safe_action

  def safe_action
  	# something that does not require authentication
  end
end
```

As you'd expect, `current_user` can be used from within controllers to access the authenticated user.

When authentication fails, Pollett raises a `Pollett::Unauthorized` error. You should [rescue_from](http://guides.rubyonrails.org/action_controller_overview.html#rescue-from) this to customize what is rendered.

### Email
Pollett is capable of sending two types of emails. In addition to the standard password reset email, it will send a welcome email upon registration unless `config.send_welcome_email` is set to `false`.

These emails will make use of whatever `layout` you have specified in your `ApplicationMailer`. If you need to customize the subject of these emails or make minor tweaks to the messages, you can simply override them via [i18n translations]
(http://guides.rubyonrails.org/i18n.html). See [config/locales/en.yml](/config/locales/en.yml) for the
default behavior.

If you need to make more elaborate changes, you'll want to override the actual views. See [app/views/pollett/mailer](/app/views/pollett/mailer) for the default behavior.
