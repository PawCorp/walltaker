class AddLastPingFromColumnToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :last_ping_user_agent, :string
  end
end
