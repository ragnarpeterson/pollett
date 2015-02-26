# This migration comes from pollett (originally 20150226024505)
class EnableUuidExtension < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"
  end
end
