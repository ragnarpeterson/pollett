require "rails/generators/base"
require "rails/generators/active_record"

module Pollett
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)

      def mount
        inject_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
          "  mount Pollett::Engine => \"/\"\n\n"
        end
      end

      def create_initializer
        copy_file "initializer.rb", "config/initializers/pollett.rb"
      end

      def inject_into_application_controller
        inject_into_class "app/controllers/application_controller.rb", ApplicationController do
          "  include Pollett::Controller\n"
        end
      end

      def create_or_inject_into_user_model
        if File.exist? "app/models/user.rb"
          inject_into_file "app/models/user.rb", after: "class User < ActiveRecord::Base\n" do
            "  include Pollett::User\n\n"
          end
        else
          copy_file "user.rb", "app/models/user.rb"
        end
      end

      def create_users_migration
        if users_table_exists?
          create_add_columns_migration
        else
          copy_migration "create_users.rb"
        end
      end

      def install_migrations
        Dir.chdir(Rails.root) { `rake pollett:install:migrations` }
      end

      private
      def users_table_exists?
        ActiveRecord::Base.connection.table_exists?(:users)
      end

      def create_add_columns_migration
        if migration_needed?
          config = {
            new_columns: new_columns,
            new_indexes: new_indexes
          }

          copy_migration("add_pollett_to_users.rb", config)
        end
      end

      def migration_needed?
        new_columns.any? || new_indexes.any?
      end

      def new_columns
        @new_columns ||= {
          email: "t.string :email, null: false",
          password_digest: "t.string :password_digest, null: false",
          reset_token: "t.string :reset_token"
        }.reject { |column| existing_users_columns.include?(column.to_s) }
      end

      def new_indexes
        @new_indexes ||= {
          index_users_on_email: "add_index :users, :email, unique: true",
          index_users_on_reset_token: "add_index :users, :reset_token, unique: true"
        }.reject { |index| existing_users_indexes.include?(index.to_s) }
      end

      def copy_migration(migration_name, config = {})
        unless migration_exists?(migration_name)
          migration_template(
            "db/migrate/#{migration_name}",
            "db/migrate/#{migration_name}",
            config
          )
        end
      end

      def migration_exists?(name)
        existing_migrations.include?(name)
      end

      def existing_migrations
        @existing_migrations ||= Dir.glob("db/migrate/*.rb").map do |file|
          migration_name_without_timestamp(file)
        end
      end

      def migration_name_without_timestamp(name)
        name.sub(%r{^.*(db/migrate/)(?:\d+_)?}, "")
      end

      def existing_users_columns
        ActiveRecord::Base.connection.columns(:users).map(&:name)
      end

      def existing_users_indexes
        ActiveRecord::Base.connection.indexes(:users).map(&:name)
      end

      # for generating a timestamp when using `create_migration`
      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end
    end
  end
end
