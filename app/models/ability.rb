class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # 总裁
    if user.manager?
      can :read, :all
    end

    # 客服主管
    if user.dispatcher_manager?
      can :check, Question
    end

    # 客服
    if user.dispatcher?
      can :read, Question
    end

  end
end
