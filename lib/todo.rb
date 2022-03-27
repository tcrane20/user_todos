class Todo
  attr_reader :id, :user_id, :title, :completed

  def self.create(todo)
    Todos.data[todo[:id]] ||= new(todo[:id], todo[:userId],
                                  todo[:title], todo[:completed])
  end

  def initialize(id, user_id, title, completed)
    @id = id
    @user_id = user_id
    @title = title
    @completed = completed
  end
end
