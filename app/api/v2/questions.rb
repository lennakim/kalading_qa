module V2
  class Questions < Grape::API
    helpers V2::SharedParams

    resources :questions do
      desc '我回答过的问题 | 技师app', {
        headers: DescHeaders.authentication_headers(source: 'engineer'),
        notes: <<-NOTE
          返回值
          -----
          ~~~
            [
              {
                "id": 1,
                "content": "问题内容",
                "auto_submodel_full_name": "车型",
                "images": ["http://..."],
                "answers_count": 4
              }
            ]
          ~~~
        NOTE
      }
      params do
        use :pagination
      end
      get :my_answered do
        authenticate!

        questions = QuestionAssignment.answered(current_resource.internal_id)
                                      .order(updated_at: :desc)
                                      .includes(:question)
                                      .page(params[:page])
                                      .per(params[:per_page])
                                      .map(&:question)
        present questions, with: V2::Entities::Question
      end

      desc '可抢答问题列表 | 技师app', {
        headers: DescHeaders.authentication_headers(source: 'engineer'),
        notes: <<-NOTE
          返回值
          -----
          ~~~
            [
              {
                "id": 1,
                "content": "问题内容",
                "auto_submodel_full_name": "车型",
                "images": ["http://..."],
                "answers_count": 4
              }
            ]
          ~~~
        NOTE
      }
      params do
        use :pagination
      end
      get :can_be_raced do
        authenticate!

        questions = Question.where(can_be_raced: true)
                            .page(params[:page])
                            .per(params[:per_page])
        present questions, with: V2::Entities::Question
      end

    end
  end
end
