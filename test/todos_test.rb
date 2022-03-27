require 'test_helper'

describe Todos do
  after do
    Todos.data.clear
  end

  it 'returns the data hash' do
    assert_kind_of Hash, Todos.data
    assert_empty Todos.data
  end

  describe 'for_user' do
    before do
      params = {
        id: 1,
        userId: 1,
        title: 'Some title',
        completed: true
      }
      Todo.create(params)
      Todo.create(params.merge(id: 2))
      Todo.create(params.merge(id: 3, completed: false))
      Todo.create(params.merge(id: 4, userId: 2))
    end

    it 'returns all todos for a user' do
      todos = Todos.for_user(1)
      assert_equal 3, todos.size
      assert_equal [1, 2, 3], todos.map { |t| t.id }

      todos = Todos.for_user(2)
      assert_equal 1, todos.size
      assert_equal [4], todos.map { |t| t.id }

      todos = Todos.for_user(3)
      assert_equal 0, todos.size
    end

    it 'returns all completed todos for a user' do
      assert_equal 2, Todos.for_user(1, completed_only: true).size
      assert_equal 1, Todos.for_user(2, completed_only: true).size
    end
  end
end
