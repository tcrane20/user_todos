class Todos
  @@_data = {}

  def self.data
    @@_data
  end

  def self.for_user(id, completed_only: false)
    data.values.select do |todo|
      todo.user_id == id && (!completed_only || todo.completed)
    end
  end
end
