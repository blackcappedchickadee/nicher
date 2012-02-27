require 'test_helper'

class FileStoragesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => FileStorage.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    FileStorage.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    FileStorage.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to file_storage_url(assigns(:file_storage))
  end

  def test_edit
    get :edit, :id => FileStorage.first
    assert_template 'edit'
  end

  def test_update_invalid
    FileStorage.any_instance.stubs(:valid?).returns(false)
    put :update, :id => FileStorage.first
    assert_template 'edit'
  end

  def test_update_valid
    FileStorage.any_instance.stubs(:valid?).returns(true)
    put :update, :id => FileStorage.first
    assert_redirected_to file_storage_url(assigns(:file_storage))
  end

  def test_destroy
    file_storage = FileStorage.first
    delete :destroy, :id => file_storage
    assert_redirected_to file_storages_url
    assert !FileStorage.exists?(file_storage.id)
  end
end
