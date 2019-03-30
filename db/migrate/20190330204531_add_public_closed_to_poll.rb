class AddPublicClosedToPoll < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :public, :boolean, default: true
    add_column :polls, :closed, :boolean, default: false
  end
end
