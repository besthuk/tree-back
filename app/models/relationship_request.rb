class RelationshipRequest < ApplicationRecord
  belongs_to :type1, class_name: "RelationshipType", optional: true
  belongs_to :type2, class_name: "RelationshipType", optional: true
end
