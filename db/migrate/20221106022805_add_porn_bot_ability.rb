class AddPornBotAbility < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TYPE ability ADD VALUE 'can_be_set_by_porn_bot';
    SQL
  end
end
