class Group < ApplicationRecord
  attr_accessor :users, :inbox, :outbox, :feed

  def get_users
    gu = GroupUser.where('group_id = ?', self.id)
    if gu
      self.users = []
      gu.each do |row|
        self.users.push(get_userdata(row.user_id))
      end
      self.users
    end
  end

  def get_inbox
    requests = GroupUserRequest.where('group_id = ? AND type_request = 1', self.id)
    if requests
      self.inbox = []
      requests.each do |row|
        self.inbox.push({'status' => row.status, 'user' => get_userdata(row.user_id)})
      end
      GroupUserRequest.where('group_id = ? AND type_request = 0 AND status = 1', self.id).update(:status => 1)
      self.inbox
    end
  end

  def get_outbox
    requests = GroupUserRequest.where('group_id = ? AND type_request = 0', self.id)
    if requests
      self.outbox = []
      requests.each do |row|
        self.outbox.push({'status' => row.status, 'description' => row.description, 'user' => get_userdata(row.user_id)})
      end
      self.outbox
    end
  end

  def get_feed
    messages = GroupMessage.where('group_id = ?', self.id)
    if messages
      self.feed = []
      messages.each do |row|
        row.get_owner
        self.feed.push(row.as_json(
            :methods => [:owner],
        ))
      end
      self.feed
    end
  end

  def check_user(id)
    gu = GroupUser.where('group_id = ? AND user_id = ?', self.id, id)
    (gu.empty?) ? false : true
  end
  private
  def get_userdata(id)
    pi = User.find_by_id(id).personal_info
    pi.user = id
    pi.as_json(
        :methods => [:user],
        :except => [:created_at, :updated_at, :id, :country, :city, :address, :hobbies]
    )
  end
end
