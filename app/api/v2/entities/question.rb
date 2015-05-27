module V2
  module Entities
    class Question < BaseEntity
      expose :id
      expose :content
      expose :auto_submodel_full_name
      expose :images
      expose :answers_count
    end
  end
end
