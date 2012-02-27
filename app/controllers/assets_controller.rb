class AssetsController < ApplicationController
  def index
    if current_user != nil
      @assets = current_user.assets
    else 
      redirect_to new_user_session_path
    end
  end

  def show
    @asset = current_user.assets.find(params[:id])
  end
  
  #this action will let the users download the files (after a simple authorization check)  
  def get  
    if current_user != nil
      puts 'test - not nil'
      asset = current_user.assets.find_by_id(params[:id])  
      if asset  
          send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type  
        else  
          flash[:error] = "Access is only allowed to your own assets."   
          redirect_to assets_path  
        end
    else 
        redirect_to new_user_session_path  
    end
  end

  def new
    @asset = current_user.assets.build      
    if params[:folder_id] #if we want to upload a file inside another folder  
       @current_folder = current_user.folders.find(params[:folder_id])  
       @asset.folder_id = @current_folder.id  
    end
    
  end

  def create
      @asset = current_user.assets.build(params[:asset])  
       if @asset.save  
        flash[:notice] = "Successfully uploaded the file."  

        if @asset.folder #checking if we have a parent folder for this file  
          redirect_to browse_path(@asset.folder)  #then we redirect to the parent folder  
        else  
          redirect_to root_url  
        end        
       else  
        render :action => 'new'  
       end
  end

  def edit
    @asset = current_user.assets.find(params[:id])
  end

  def update
    @asset = current_user.assets.find(params[:id])
    if @asset.update_attributes(params[:asset])
      redirect_to @asset, :notice  => "Successfully updated asset."
    else
      render :action => 'edit'
    end
  end

  def destroy
      @asset = current_user.assets.find(params[:id])  
      @parent_folder = @asset.folder #grabbing the parent folder before deleting the record 
      deleted_file_name = @asset.file_name
      @asset.destroy  
      local_notice_destroy = "Successfully deleted the file named #{deleted_file_name}."  

      #redirect to a relevant path depending on the parent folder  
      if @parent_folder  
       redirect_to browse_path(@parent_folder), :notice => local_notice_destroy
      else  
       redirect_to root_url, :notice => local_notice_destroy
      end
  end
  
end
