class AddAdditionalMetafieldsToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :file_comments, :string
    add_column :assets, :file_version, :integer
    add_column :assets, :file_storage_id, :integer

    add_index :assets, :file_storage_id

  end
end
