class AssetsController < ApplicationController
  def index
    # @assets = Asset.all
    if current_user != nil
      @assets = current_user.assets
    else 
      redirect_to new_user_session_path
    end
  end

  def show
    #@asset = Asset.find(params[:id])
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
          flash[:error] = "Don't be cheeky! Mind your own assets!"  
          redirect_to assets_path  
        end
    else 
        redirect_to new_user_session_path  
    end
  end

  def new
    #@asset = Asset.new
    @asset = current_user.assets.new
  end

  def create
      #@asset = Asset.new(params[:asset])
      @asset = current_user.assets.new(params[:asset])
      if @asset.save
        redirect_to @asset, :notice => "Successfully created asset."
      else
        render :action => 'new'
      end
  end

  def edit
    #@asset = Asset.find(params[:id])
    @asset = current_user.assets.find(params[:id])
  end

  def update
    #@asset = Asset.find(params[:id])
    @asset = current_user.assets.find(params[:id])
    if @asset.update_attributes(params[:asset])
      redirect_to @asset, :notice  => "Successfully updated asset."
    else
      render :action => 'edit'
    end
  end

  def destroy
    #@asset = Asset.find(params[:id])
    @asset = current_user.assets.find(params[:id])
    @asset.destroy
    redirect_to assets_url, :notice => "Successfully destroyed asset."
  end
  
end
