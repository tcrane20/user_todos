class User
  attr_reader :id

  def self.create(id)
    Users.data[id] ||= new(id)
  end

  def initialize(id)
    @id = id
  end
end
