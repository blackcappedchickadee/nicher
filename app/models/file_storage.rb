class FileStorage < ActiveRecord::Base
  attr_accessible :file_storage_id
  
  belongs_to :assets
end
