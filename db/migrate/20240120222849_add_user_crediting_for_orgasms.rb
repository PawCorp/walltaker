class AddUserCreditingForOrgasms < ActiveRecord::Migration[7.1]
  def change
    add_column :nuttracker_orgasms, :caused_by_user_id, :bigint, null: true
    add_index :nuttracker_orgasms, :caused_by_user_id
  end
end
