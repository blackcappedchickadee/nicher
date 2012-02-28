class HomeController < ApplicationController  
    
  def index  
     if user_signed_in?  

       #show only root folders (which have no parent folders)  
       @folders = current_user.folders.roots   

       #show only root files which has no "folder_id", and limit the view to master version files
       @assets = current_user.assets.where("folder_id is NULL AND is_master_version = 1").order("uploaded_file_file_name desc")
       
       @url_prior_to_edit = request.fullpath
       session[:url_prior_to_edit] = @url_prior_to_edit
            
      end
  end  
  
  #this action is for viewing folders  
  def browse 
      if user_signed_in?  
     
        #get the folders owned/created by the current_user  
        @current_folder = current_user.folders.find(params[:folder_id])    
    
        if @current_folder  
      
          #getting the folders which are inside this @current_folder  
          @folders = @current_folder.children  
    
          #show only files under this current folder, and limit the view to master version files
          @assets = @current_folder.assets.where("is_master_version = 1").order("uploaded_file_file_name desc")

          render :action => "index"  
        else  
          flash[:error] = "Access is only allowed to your own folders."  
          redirect_to root_url  
        end  
        
        @url_prior_to_edit = request.fullpath
        session[:url_prior_to_edit] = @url_prior_to_edit
        
      end
  end
  
end