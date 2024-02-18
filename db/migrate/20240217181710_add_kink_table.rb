class AddKinkTable < ActiveRecord::Migration[7.1]
  def change
    create_table :kinks do |t|
      t.string :name, null: false, limit: 30
    end
  end
end
