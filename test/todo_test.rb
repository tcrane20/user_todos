require 'test_helper'

describe Todo do
  after do
    Todos.data.clear
  end

  it 'creates a new todo' do
    params = {
      id: 1,
      userId: 2,
      title: 'A title',
      completed: false
    }
    todo = Todo.create(params)
    assert_equal 1, todo.id
    assert_equal todo, Todos.data[1]
  end

  it 'does not overwrite an existing todo' do
    params = {
      id: 5,
      userId: 10,
      title: 'Some title',
      completed: true
    }
    todo = Todo.create(params)
    params[:title] = 'Different title'
    same_todo = Todo.create(params)
    assert_equal todo, same_todo
  end
end
