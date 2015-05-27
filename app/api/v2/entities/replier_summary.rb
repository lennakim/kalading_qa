module V2
  module Entities
    class ReplierSummary < BaseEntity
      format_with(:year_month) { |m| m.strftime("%Y年%-m月") }

      expose :id
      expose :month, format_with: :year_month
      expose :answers_count
      expose :adoptions_count
      expose :bonus
    end
  end
end
