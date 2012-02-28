class Asset < ActiveRecord::Base
  attr_accessible :user_id, :uploaded_file, :uploaded_file_file_name, :delete_file, :folder_id, :file_comments, :file_version, :file_storage_id, :uploaded_file_updated_at
  
  belongs_to :folder
  
  has_one :file_storage
  
 # before_validation { uploaded_file.clear if :delete_asset == '1' }
  
  
  # set up "uploaded file" field as attached_file (using Paperclip)
  has_attached_file :uploaded_file, 
                   :url => "/assets/get/:id",  
                   :path => ":Rails_root/assets/:id/:basename.:extension" 
                  # :styles => { :thumb => "16x16>" },
                  # :whiny => false
  
  validates_attachment_size :uploaded_file, :less_than => 100.megabytes #todo -- pull this in from environment
  validates_attachment_presence :uploaded_file
  
  #implement full text searching
  searchable do
    text :uploaded_file_file_name, :boost =>5 #the filename is 5x more "important" in a search. Relevance search.
    text :file_comments, :uploaded_month
    
    #allow filtering by user_id
    integer :user_id
    #allow filtering by is_master_version
    integer :is_master_version
    
  end
  
  def uploaded_month
    uploaded_file_updated_at.strftime("%B %Y")
  end
  
  def file_name
    uploaded_file_file_name
  end 
  
  def file_size  
      uploaded_file_file_size  
  end
  
  # Obtain a thumbnail related to the 
  #def thumbnail_uri(style = :original)
  #  if style == :original || has_thumbnail?
  #    # we'll enable this once we implement AWS S2 support:
  #    #uploaded_file.s3.interface.get_link(uploaded_file.s3_bucket.to_s, uploaded_file.path(style), EXPIRES_AFTER)
  #    
  #    # in the meantime, refer to local storage:
  #    
  #    uploaded_file.get_path
  #    
  #    
  #  else
  #    generic_icon_path style
  #  end
  # end
  
  
end
