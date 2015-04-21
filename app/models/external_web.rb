# 访问「网站数据库」的Model的父类
class ExternalWeb < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :kalading_web
end
