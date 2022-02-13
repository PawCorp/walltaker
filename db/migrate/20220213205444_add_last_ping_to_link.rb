class AddLastPingToLink < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :last_ping, :timestamp
  end
end
