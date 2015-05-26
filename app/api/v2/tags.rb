module V2
  class Tags < Grape::API
    resources :tags do
      desc '标签列表'
      get '/' do
        tags = ActsAsTaggableOn::Tag.all

        present tags, with: V2::Entities::Tag
      end
    end
  end
end
