class CreateLinkAbilitiesTable < ActiveRecord::Migration[7.0]
  def up
    create_enum :ability, ["can_show_videos"]

    create_table :link_abilities do |t|
      t.references :link, null: false, foreign_key: true
      t.enum :ability, enum_type: "ability", null: false

      t.timestamps
    end
  end

  def down
    drop_table :link_abilities
  end
end
