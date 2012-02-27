class AddIsMasterVersionToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :is_master_version, :bit

  end
end
