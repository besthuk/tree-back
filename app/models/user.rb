class User < ApplicationRecord
  has_many :studies
  has_many :works
  belongs_to :personal_info

  attr_accessor :relationships
  attr_accessor :children
  attr_accessor :parents
  attr_accessor :spouse

  belongs_to :parent_1, class_name: "User", optional: true
  belongs_to :parent_2, class_name: "User", optional: true

  before_create -> {self.token = generate_token_}

  def generate_code(type, new_value = nil)
    # TODO test
    # code = Random.rand(1000..9999)
    code = 1234
    time_code = 5.minute.from_now(Time.now)
    self.update(:code => code, :time_code => time_code, :code_type => type, :new_value => new_value)
  end

  def generate_token
    token = generate_token_
    self.update(:token => token, :time_code => Time.now)
    token
  end

  def get_relatives
    self.children = []
    self.parents = []
    if self.parent_1_id.nil? == false
      self.parents.push(get_userdata(parent_1_id))
    end
    if self.parent_2_id.nil? == false
      self.parents.push(get_userdata(parent_2_id))
    end
    if self.spouse_id.nil? == false
      self.spouse = get_userdata(self.spouse_id)
    end
    children = User.where('parent_1_id=? OR parent_1_id=?', self.id, self.id)
    if children
      children.each do |user|
        self.children.push(get_userdata(user.id))
      end
    end
    self.relationships = {'parents' => self.parents, 'children' => self.children, 'spouse' => self.spouse}
=begin
    rel = Relationship.where('user1_id=? OR user2_id=?', self.id, self.id)
    if rel
      self.relationships = []
      rel.each do |user|
        if user.user1_id == self.id
          self.relationships.push(get_userdata(user.user2_id, user.type2.name))
        else
          self.relationships.push(get_userdata(user.user1_id, user.type1.name))
        end
      end
      self.relationships
    end
=end
  end

  def check_relationship(id)
    check = false
    if self.parent_1_id == id || self.parent_2_id == id || self.spouse_id == id
      check = true
    end
    check
=begin
    rel = Relationship.where('user1_id=? OR user2_id=?', self.id, self.id)
    check = false
    if rel
      rel.each do |user|
        if
          (user.user1_id == self.id && user.user2_id == id) ||
          (user.user2_id == self.id && user.user1_id == id)
          check = true
        end
      end
    end
    check
=end
  end

  def check_relationship_request(id)
    rel = RelationshipRequest.where('user1_id=? AND user2_id=?', id, self.id)
    (rel.empty?) ? false : true
  end
  private
  def get_userdata(id, type = false)
    pi = User.find_by_id(id).personal_info
    pi.type = type
    pi.user = id
    pi.as_json(
        :methods => [:type, :user],
        :except => [:created_at, :updated_at, :id, :country, :city, :address, :hobbies]
    )
  end
  def generate_token_
    loop do
      token = SecureRandom.hex
      return token unless User.exists?({token: token})
    end
  end
end
