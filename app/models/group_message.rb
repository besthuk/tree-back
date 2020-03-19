class GroupMessage < ApplicationRecord
  attr_accessor :owner
  def get_owner
    self.owner = get_userdata(owner_id)
  end

  private
  def get_userdata(id)
    user = User.find_by_id(id)
    if user
      pi = user.personal_info
      pi.user = id
      pi.as_json(
          :methods => [:user],
          :except => [:created_at, :updated_at, :id, :country, :city, :address, :hobbies]
      )
    end
  end
end
