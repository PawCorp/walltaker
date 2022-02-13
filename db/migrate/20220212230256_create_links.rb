class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.datetime :expires
      t.references :user, null: false, foreign_key: true
      t.string :terms

      t.timestamps
    end
  end
end
