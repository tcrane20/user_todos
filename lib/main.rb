require_relative 'app_helper.rb'

json_data = UserTodosApi.load_json
UserTodosApi.create_users_and_todos(json_data)

puts UserTodosApi.display_top_user
puts UserTodosApi.display_leaderboard
