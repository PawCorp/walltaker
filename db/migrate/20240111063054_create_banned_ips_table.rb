class CreateBannedIpsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :banned_ips do |t|
      t.string :ip_address, index: true
      t.references :banned_by, index: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
