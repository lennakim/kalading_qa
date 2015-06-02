module V2
  class Tags < Grape::API
    namespace :tags, desc: '', swagger: {nested: false, name: '标签'} do
      desc '标签列表'
      get '/' do
        tags = ActsAsTaggableOn::Tag.all

        present tags, with: V2::Entities::Tag
      end
    end
  end
end
