class AddAhoyIdToLinkAndPastLink < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :ahoy_visit_id, :bigint
    add_column :past_links, :ahoy_visit_id, :bigint
  end
end
