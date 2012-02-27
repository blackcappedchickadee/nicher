class CreateFileStorages < ActiveRecord::Migration
  def self.up
    create_table :file_storages do |t|
      t.integer :file_storage_id
      t.timestamps
    end
    
    add_index :file_storages, :file_storage_id
    
  end

  def self.down
    drop_table :file_storages
  end
end
