class AddContentToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :content, :text
  end
end
