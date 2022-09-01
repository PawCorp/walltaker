class AddThreadNameToMessageThreads < ActiveRecord::Migration[7.0]
  def change
    add_column :message_threads, :name, :string
  end
end
