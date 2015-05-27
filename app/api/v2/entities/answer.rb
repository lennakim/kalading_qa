module V2
  module Entities
    class Answer < BaseEntity
      expose :id
      expose :content
      expose :created_at, format_with: :datetime
      expose :adopted?, as: :adopted
      expose :replier, using: V2::Entities::Replier
    end
  end
end
