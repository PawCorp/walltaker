# This migration comes from nuttracker (originally 20220628220822)
class CreateNuttrackerOrgasms < ActiveRecord::Migration[7.0]
  def change
    create_table :nuttracker_orgasms do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :is_ruined
      t.integer :rating

      t.timestamps
    end
  end
end
