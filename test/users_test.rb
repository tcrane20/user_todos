require 'test_helper'

describe Users do
  it 'returns the data hash' do
    assert_kind_of Hash, Users.data
    assert_empty Users.data
  end
end
