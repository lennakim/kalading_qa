module V2
  module SharedParams
    extend Grape::API::Helpers

    params :pagination do |options|
      options[:per_page] ||= 10

      optional :page, type: Integer, default: 1, desc: '第几页，默认是1'
      optional :per_page, type: Integer, default: options[:per_page], desc: "每页返回数，默认是#{options[:per_page]}"
    end
  end
end
