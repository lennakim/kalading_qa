module V2
  class Questions < Grape::API
    helpers V2::SharedParams
    SUMMARY_RESPONSE = <<-NOTE
      返回值
      -----
      ~~~
      [
        {
          "id": 1,
          "content": "问题内容",
          "auto_submodel_full_name": "车型",
          "answers_count": 4,
          "has_images": true
        }
      ]
      ~~~
    NOTE

    resources :questions do
      desc '我回答过的问题 | 技师app', {
        headers: DescHeaders.authentication_headers(source: 'engineer'),
        notes: SUMMARY_RESPONSE
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
        present questions, with: V2::Entities::Question, type: :summary
      end

      desc '可抢答问题列表 | 技师app', {
        headers: DescHeaders.authentication_headers(source: 'engineer'),
        notes: SUMMARY_RESPONSE
      }
      params do
        use :pagination
      end
      get :can_be_raced do
        authenticate!

        questions = Question.where(can_be_raced: true)
                            .page(params[:page])
                            .per(params[:per_page])
        present questions, with: V2::Entities::Question, type: :summary
      end

      desc '抢答问题 | 技师app', {
        headers: DescHeaders.authentication_headers(source: 'engineer'),
        notes: <<-NOTE
          抢答是指抢到某个问题的回答权，而不是真的回答问题

          返回值
          -----

          抢答成功

          ~~~
          {
            "code": 0,
            "msg": []
          }
          ~~~

          <br>
          抢答失败

          ~~~
          {
            "code": -1,
            "msg": [
              "您不能抢答此题"
            ]
          }
          ~~~
        NOTE
      }
      put ':id/race' do
        authenticate!

        question = Question.find(params[:id])
        result = question.race_by_engineer(current_resource.internal_id)

        if result
          present :code, 0
          present :msg, []
        else
          present :code, -1
          present :msg, question.errors.full_messages
        end
      end

      desc '回答问题 | 技师app', {
        headers: DescHeaders.authentication_headers(source: 'engineer'),
        notes: <<-NOTE
          返回值
          -----

          回答成功

          ~~~
          {
            "code": 0,
            "msg": []
          }
          ~~~

          <br>
          回答失败

          ~~~
          {
            "code": -1,
            "msg": [
              "您不能回答此题"
            ]
          }
          ~~~
        NOTE
      }
      params do
        requires :content, type: String, desc: '答案内容'
      end
      post ':id/answers' do
        authenticate!

        question = Question.find(params[:id])
        answer = question.answer(
                   replier_id: current_resource.internal_id,
                   replier_type: 'engineer',
                   content: params[:content]
                 )

        if answer.persisted?
          present :code, 0
          present :msg, []
        else
          present :code, -1
          present :msg, answer.errors.full_messages
        end
      end

      desc '客户问题列表 | 问答app', {
        headers: DescHeaders.authentication_headers(source: 'customer'),
        notes: SUMMARY_RESPONSE
      }
      params do
        use :pagination
      end
      get :customer_questions do
        authenticate!

        questions = Question.where(customer_id: current_resource.id)
                            .order(created_at: :desc)
                            .page(params[:page])
                            .per(params[:per_page])
        present questions, with: V2::Entities::Question, type: :summary
      end

      # swagger-ui目前的最新版2.1.1-M2已经解决了notes里说的问题，等swagger-ui_rails更新吧
      #
      # 多图片可以用curl测试：
      # curl -v -F "images[][image]=@图片_01.jpg" -F "images[][image]=@图片_02.jpg" http://localhost:3000/api/v2/questions.json
      desc '创建问题 | 问答app', {
        headers: DescHeaders.authentication_headers(source: 'customer'),
        notes: <<-NOTE
          注：
          目前用的swagger-ui版本（swagger-ui_rails: 0.1.7, swagger-ui: 2.1.0-alpha.7）有bug
          API有upload file的话，parse response错误，导致返回值等信息无法在UI上呈现

          返回值
          -----

          创建成功

          ~~~
          {
            "code": 0,
            "question": {
              "id": 1,
              "content": "问题内容",
              "auto_submodel_full_name": "车型",
              "answers_count": 0,
              "images": ["http://..."],
              "created_at": "2015-05-27",
              "answers": []
            }
          }
          ~~~

          <br>
          创建失败

          ~~~
          {
            "code": -1,
            "msg": [
              "内容不能为空"
            ]
          }
          ~~~
        NOTE
      }
      params do
        requires :auto_submodel_id, type: String, desc: '车型的后台id'
        requires :content, type: String, desc: '问题内容'

        optional :images, type: Array do
          requires :image, type: Rack::Multipart::UploadedFile, desc: '图片'
        end
      end
      post '/' do
        authenticate!

        question = Question.new(
                     customer_id: current_resource.id,
                     auto_submodel_internal_id: params[:auto_submodel_id],
                     content: params[:content],
                     images: params[:images].map(&:image)
                   )

        if question.save
          present :code, 0
          present :question, question, with: V2::Entities::Question, type: :with_answers
        else
          present :code, -1
          present :msg, question.errors.full_messages
        end
      end

      desc '问题明细 | 技师app，问答app', {
        headers: DescHeaders.authentication_headers,
        notes: <<-NOTE
          返回值
          -----
          ~~~
          {
            "id": 1,
            "content": "问题内容",
            "auto_submodel_full_name": "车型",
            "answers_count": 1,
            "images": ["http://..."],
            "created_at": "2015-05-27",
            "answers": [
              {
                "id": 24,
                "content": "答案",
                "created_at": "2015-05-27 14:32:54",
                "adopted": false,
                "replier": {
                  "internal_id": "55264ab17e2d818ef5000002",
                  "name": "回答者"
                }
              }
            ]
          }
          ~~~
        NOTE
      }
      get ':id', requirements: { id: /[0-9]+/ } do
        authenticate!

        case source
        when 'engineer'
          question = QuestionAssignment.find_by!(user_internal_id: current_resource.internal_id,
                                                 question_id: params[:id]).question
        when 'customer'
          question = Question.find_by!(id: params[:id], customer_id: current_resource.id)
        end
        present question, with: V2::Entities::Question, type: :with_answers
      end

    end
  end
end
