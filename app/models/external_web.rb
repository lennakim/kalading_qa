class ExternalWeb < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :kalading_web
end
