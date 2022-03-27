require 'test_helper'

describe UserTodosApi do
  it 'gets the JSON from the URL' do
    uri_parse_stub = stub
    URI.expects(:parse).with(UserTodosApi::TODOS_URL)
                       .returns(uri_parse_stub)
    JSON.expects(:load).with(uri_parse_stub, nil,
                             symbolize_names: true,
                             create_additions: false).once
    UserTodosApi.load_json
  end

  it 'loads JSON data to create users and todos' do
    todo1 = { id: 1, userId: 1, title: 'a', completed: false }
    todo2 = { id: 2, userId: 2, title: 'b', completed: false }
    todo3 = { id: 3, userId: 2, title: 'c', completed: true }
    User.expects(:create).with(1).once
    User.expects(:create).with(2).twice
    Todo.expects(:create).with(todo1).once
    Todo.expects(:create).with(todo2).once
    Todo.expects(:create).with(todo3).once
    UserTodosApi.create_users_and_todos([todo1, todo2, todo3])
  end

  it 'gets the completed count for all users' do
    users = {
      1 => stub(id: 1),
      2 => stub(id: 2),
      3 => stub(id: 3)
    }
    todos = {
      1 => stub(id: 1, user_id: 1, title: 'a', completed: false ),
      2 => stub(id: 2, user_id: 1, title: 'b', completed: true ),
      3 => stub(id: 3, user_id: 2, title: 'c', completed: true ),
      4 => stub(id: 4, user_id: 2, title: 'd', completed: true ),
      5 => stub(id: 5, user_id: 3, title: 'e', completed: false )
    }
    Users.stubs(:data).returns(users)
    Todos.stubs(:data).returns(todos)
    list = UserTodosApi.get_completed_counts_for_all_users
    assert_equal [2, 2], list[0]
    assert_equal [1, 1], list[1]
    assert_equal [3, 0], list[2]
  end

  describe '#get_most_completed_users' do
    it 'returns one user' do
      list = [[3, 5], [2, 4], [1, 0]]
      UserTodosApi.expects(:get_completed_counts_for_all_users)
                  .returns(list)
      assert_equal [3], UserTodosApi.get_most_completed_users
    end

    it 'returns more than one user' do
      list = [[2, 5], [3, 5], [1, 4], [4, 0]]
      UserTodosApi.expects(:get_completed_counts_for_all_users)
                  .returns(list)
      assert_equal [2, 3], UserTodosApi.get_most_completed_users
    end
  end

  it 'writes out the user with the most completed todos' do
    UserTodosApi.expects(:get_most_completed_users).returns([2])
    text = UserTodosApi.display_top_user
    assert_equal 'User(s) with most todos completed: 2', text
  end

  it 'writes out the completed todos leaderboard' do
    list = [[2, 5], [3, 5], [1, 4], [4, 0]]
    UserTodosApi.expects(:get_completed_counts_for_all_users)
                .returns(list)
    text = UserTodosApi.display_leaderboard
    expected_text = <<~TEXT
      Rank  User#  Completed Todos
      ----  -----  ---------------
      1     2      5
            3      5
      3     1      4
      4     4      0
    TEXT
    assert_equal expected_text, text
  end
end
