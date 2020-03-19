class Relationship < ApplicationRecord
  # belongs_to :user
  # belongs_to :user
  # belongs_to :relationship_type
  # belongs_to :relationship_type
  belongs_to :type1, class_name: "RelationshipType", optional: true
  belongs_to :type2, class_name: "RelationshipType", optional: true

  attr_accessor :type, :to_user
end
