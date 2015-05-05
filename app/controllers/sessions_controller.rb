class SessionsController < Devise::SessionsController
  layout 'session'

  def create
    if Rails.env.development? && Settings.use_local_data == true
      super and return
    end

    render action: 'new'
  end
end
