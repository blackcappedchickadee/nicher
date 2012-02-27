class AddAdditionalFieldsToFileStorages < ActiveRecord::Migration
  def change
    add_column :file_storages, :file_storage_description, :string

  end
end
