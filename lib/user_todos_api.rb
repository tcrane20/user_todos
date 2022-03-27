module UserTodosApi
  TODOS_URL = 'https://jsonplaceholder.typicode.com/todos'

  def self.load_json
    JSON.load(URI.parse(TODOS_URL), nil,
              symbolize_names: true,
              create_additions: false)
  end

  def self.create_users_and_todos(data)
    data.each do |todo|
      User.create(todo[:userId])
      Todo.create(todo)
    end
  end

  def self.get_completed_counts_for_all_users
    Users.data.values.map do |user|
      [user.id, Todos.for_user(user.id, completed_only: true).size]
    end.sort { |a, b| b[1] <=> a[1] }
  end

  def self.get_most_completed_users
    user_counts = get_completed_counts_for_all_users
    max = 0
    users = []
    user_counts.each do |user_id, count|
      break unless count >= max
      max = count
      users << user_id
    end
    users
  end

  def self.display_top_user
    users = get_most_completed_users
    "User(s) with most todos completed: #{users.join(', ')}"
  end

  def self.display_leaderboard
    leaderboard = get_completed_counts_for_all_users
    body = <<~TEXT
      Rank  User#  Completed Todos
      ----  -----  ---------------
    TEXT
    previous_completed = 0
    leaderboard.each_with_index do |(user_id, completed), rank|
      rank = previous_completed == completed ? nil : rank + 1
      body << format("%-4s  %-5d  %d\n", rank, user_id, completed)
      previous_completed = completed
    end
    body
  end
end
