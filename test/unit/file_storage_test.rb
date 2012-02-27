require 'test_helper'

class FileStorageTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FileStorage.new.valid?
  end
end
