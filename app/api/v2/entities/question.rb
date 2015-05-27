module V2
  module Entities
    class Question < BaseEntity
      expose :id
      expose :content
      expose :auto_submodel_full_name
      expose :answers_count

      expose :has_images?, as: :has_images, if: { type: :summary }

      expose :images, if: { type: :with_answers }
      expose :created_at, format_with: :date, if: { type: :with_answers }
      expose :answers, using: V2::Entities::Answer, if: { type: :with_answers }
    end
  end
end
