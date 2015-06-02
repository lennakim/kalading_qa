module V2
  class ReplierSummaries < Grape::API
    helpers V2::SharedParams

    namespace :replier_summaries, desc: '', swagger: {nested: false, name: '收益'} do
      desc '技师收益列表 | 技师app', {
        headers: DescHeaders.authentication_headers(source: 'engineer'),
        notes: <<-NOTE
          返回值
          -----
          ~~~
          [
            {
              "id": 1,
              "month": "2015年5月",
              "answers_count": 3,
              "adoptions_count": 1,
              "bonus": 0
            }
          ]
          ~~~
        NOTE
      }
      params do
        use :pagination, per_page: 5
      end
      get '/' do
        authenticate!

        summaries = ReplierSummary.where(replier_id: current_resource.internal_id)
                                  .order(month: :desc)
                                  .page(params[:page])
                                  .per(params[:per_page])
        present summaries, with: V2::Entities::ReplierSummary
      end
    end
  end
end
