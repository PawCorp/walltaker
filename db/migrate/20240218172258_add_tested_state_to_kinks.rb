class AddTestedStateToKinks < ActiveRecord::Migration[7.1]
  def change
    add_column :kinks, :works_on_e621, :boolean, default: false, null: false
  end
end
