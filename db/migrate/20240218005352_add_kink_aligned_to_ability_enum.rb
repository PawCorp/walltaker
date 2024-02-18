class AddKinkAlignedToAbilityEnum < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TYPE ability ADD VALUE 'is_kink_aligned';
    SQL
  end
end
