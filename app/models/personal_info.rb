class PersonalInfo < ApplicationRecord
  belongs_to :user, optional: true
  attr_accessor :type, :status, :user
end
