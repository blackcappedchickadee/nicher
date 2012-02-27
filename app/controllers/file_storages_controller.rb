class FileStoragesController < ApplicationController
  
  before_filter :authenticate_user!  #authenticate for users before any methods is called  
  
  def index
    @file_storages = FileStorage.all
  end

  def show
    @file_storage = FileStorage.find(params[:id])
  end

  def new
    @file_storage = FileStorage.new
  end

  def create
    @file_storage = FileStorage.new(params[:file_storage])
    if @file_storage.save
      redirect_to @file_storage, :notice => "Successfully created file storage."
    else
      render :action => 'new'
    end
  end

  def edit
    @file_storage = FileStorage.find(params[:id])
  end

  def update
    @file_storage = FileStorage.find(params[:id])
    if @file_storage.update_attributes(params[:file_storage])
      redirect_to @file_storage, :notice  => "Successfully updated file storage."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @file_storage = FileStorage.find(params[:id])
    @file_storage.destroy
    redirect_to file_storages_url, :notice => "Successfully destroyed file storage."
  end
end
