class AddKinkHaversTable < ActiveRecord::Migration[7.1]
  def change
    create_table :kink_havers do |t|
      t.belongs_to :kink, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
