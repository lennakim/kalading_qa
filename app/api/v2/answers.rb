module V2
  class Answers < Grape::API

    namespace :answers, desc: '', swagger: {nested: false, name: '答案'} do
      desc '采纳答案 | 问答app', {
        headers: DescHeaders.authentication_headers(source: 'customer'),
        notes: <<-NOTE
          返回值
          -----

          采纳成功

          ~~~
          {
            "code": 0,
            "msg": []
          }
          ~~~

          <br>
          采纳失败

          ~~~
          {
            "code": -1,
            "msg": [
              "您没有权限采纳此答案"
            ]
          }
          ~~~
        NOTE
      }
      params do
      end
      put ':id/adopt' do
        authenticate!

        answer = Answer.find(params[:id])
        if answer.adopt(current_resource.id, 'customer')
          present :code, 0
          present :msg, []
        else
          present :code, -1
          present :msg, answer.errors.full_messages
        end
      end

    end
  end
end
