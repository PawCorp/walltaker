class AddLiveClientStartTimeColumnToLinksTable < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :live_client_started_at, :timestamp, null: true
  end
end
