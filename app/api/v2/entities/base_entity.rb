module V2
  module Entities
    class BaseEntity < Grape::Entity
      format_with(:date) {|t| t.strftime("%Y-%m-%d") if t }
      format_with(:datetime) {|t| t.strftime("%Y-%m-%d %H:%M:%S") if t }
    end
  end
end
