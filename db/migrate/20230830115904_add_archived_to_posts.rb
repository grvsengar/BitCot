class AddArchivedToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :archived, :boolean
  end
end
