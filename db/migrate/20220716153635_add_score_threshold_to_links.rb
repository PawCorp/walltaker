class AddScoreThresholdToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :min_score, :integer
  end
end
