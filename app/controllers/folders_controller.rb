class FoldersController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @folders = current_user.folders
  end

  def show
    @folder = current_user.folders.find(params[:id])
  end

  def new
    @folder = current_user.folders.new
         #if there is "folder_id" param, we know that we are under a folder, thus, we will essentially create a subfolder  
         if params[:folder_id] #if we want to create a folder inside another folder  

         #we still need to set the @current_folder to make the buttons working fine  
         @current_folder = current_user.folders.find(params[:folder_id])  

         #then we make sure the folder we are creating has a parent folder which is the @current_folder  
         @folder.parent_id = @current_folder.id  
       end
  end

  def create
    @folder = current_user.folders.new(params[:folder]) 
    if @folder.save
      flash[:notice] = "Successfully created folder."  
      
      if @folder.parent #checking if we have a parent folder on this one  
           redirect_to browse_path(@folder.parent)  #then we redirect to the parent folder  
      else  
           redirect_to root_url #if not, redirect back to home page  
      end
      
    else
      render :action => 'new'
    end
  end

  def edit
    @folder = current_user.folders.find(params[:folder_id])  
    @current_folder = @folder.parent    #this is just for breadcrumbs
  end

  def update
    @folder = current_user.folders.find(params[:id]) 
     local_notice_update = "Successfully updated folder."
     @folder.update_attributes(params[:folder])
     @parent_folder = @folder.parent #grabbing the parent folder
     #redirect to a relevant path depending on the parent folder  
     if @parent_folder  
      redirect_to browse_path(@parent_folder), :notice  => local_notice_update
     else  
      redirect_to root_url, :notice  => local_notice_update       
     end
    
  end

  def destroy
       @folder = current_user.folders.find(params[:id])  
       @parent_folder = @folder.parent #grabbing the parent folder  
       deleted_folder_name = @folder.name
       #this will destroy the folder along with all the contents inside  
       #sub folders will also be deleted too as well as all files inside  
       @folder.destroy  
       local_notice_destroy = "Successfully deleted the folder #{deleted_folder_name} and all of the contents."  

       #redirect to a relevant path depending on the parent folder  
       if @parent_folder  
        redirect_to browse_path(@parent_folder), :notice  => local_notice_destroy
       else  
        redirect_to root_url, :notice  => local_notice_destroy        
       end
  end
end
