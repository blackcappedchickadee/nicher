class HomeController < ApplicationController  
    
  def index  
     if user_signed_in?  
       ##load current_user's folders  
       #@folders = current_user.folders.order("name desc")
       
       ##load current_user's files (assets)
       #@assets = current_user.assets.order("uploaded_file_file_name desc")  
       
       #show only root folders (which have no parent folders)  
       @folders = current_user.folders.roots   

       #show only root files which has no "folder_id"  
       @assets = current_user.assets.where("folder_id is NULL").order("uploaded_file_file_name desc")
            
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
    
         # if @assets
            #show only files under this current folder  
             @assets = @current_folder.assets.order("uploaded_file_file_name desc")  
        #  end
          
          render :action => "index"  
        else  
          flash[:error] = "Access is only allowed to your own folders."  
          redirect_to root_url  
        end  
      
      end
  end
  
end