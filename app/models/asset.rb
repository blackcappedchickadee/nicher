class Asset < ActiveRecord::Base
  attr_accessible :user_id, :uploaded_file, :uploaded_file_file_name, :delete_file, :folder_id, :file_comments, :file_version, :file_storage_id, :uploaded_file_updated_at
  
  belongs_to :folder
  
  has_one :file_storage
  
 # before_validation { uploaded_file.clear if :delete_asset == '1' }
  
  
  # set up "uploaded file" field as attached_file (using Paperclip)
  has_attached_file :uploaded_file, 
                   :url => "/assets/get/:id",  
                   :path => ":Rails_root/assets/:id/:basename.:extension"
  
  validates_attachment_size :uploaded_file, :less_than => 100.megabytes #todo -- pull this in from environment
  validates_attachment_presence :uploaded_file
  
  def file_name
    uploaded_file_file_name
  end 
  
  def file_size  
      uploaded_file_file_size  
  end
  

  
  
end
