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
      @asset.file_version = 1
      @asset.is_master_version = 1
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
    #@asset = current_user.assets.find(params[:id])
    @parent_id = 0
    @folder_id = 0
    
    if current_user != nil
      @asset = current_user.assets.find(params[:id])
    
      if @asset
        #are we at root or inside a sub-folder? all this is just for breadcrumbs, and if we change 
        #behaviour (modal jQuery - or to simply redirect back to prior view), this may not be needed
        if @asset.folder != nil
          #sub-folder
           #@folder = current_user.folders.find(params[:folder_id])  
           #@current_folder = @folder.parent    #this is just for breadcrumbs
           #@parent_id = @folder.parent_id
           #@folder_id = @current_folder.folder_id
        else
          #root
        end
       
      else
          flash[:error] = "Access is only allowed to your own assets."   
          redirect_to assets_path
      end
    else
       redirect_to new_user_session_path 
    end
  end

  def update
    
    # We mark the current file as being an "archive" at this point - since we version
    # everything that is involved with an update. This means archiving the prior version, 
    # and creating a new (asset_new) version of the asset/file, now marked as master. 
    
    asset_old = current_user.assets.find(params[:id])
    asset_old.file_version += 1 #increment the version
    asset_old.is_master_version = 0 # no longer the master version
    
    if asset_old.save 

      local_file = asset_old.uploaded_file.to_file

      asset_new = Asset.new
      asset_new.user_id = asset_old.user_id
      asset_new.uploaded_file_file_name = asset_old.uploaded_file_file_name
      asset_new.folder_id = asset_old.folder_id
      
      tmp_hash = params[:asset]
      posted_comments = tmp_hash[:file_comments]
      
      puts 'posted_comments = ' + posted_comments
      asset_new.file_comments = posted_comments
      asset_new.file_version = asset_old.file_version + 1 #increments the version
      asset_new.is_master_version = 1 # this new file is now the master version
      
      asset_new.uploaded_file = local_file
      
      if asset_new.save
        redirect_to session[:url_prior_to_edit], :notice  => "Successfully updated asset."
      end
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
