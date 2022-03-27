require 'test_helper'

describe User do
  after do
    Users.data.clear
  end

  it 'creates a new user' do
    user = User.create(1)
    assert_equal 1, user.id
    assert_equal user, Users.data[1]
  end

  it 'does not overwrite an existing user' do
    user = User.create(2)
    same_user = User.create(2)
    assert_equal user, same_user
  end
end
