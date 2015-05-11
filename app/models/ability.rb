class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # 总裁
    if user.manager?
      can :read, :all
      can [:read_init, :read_useless], Question
    end

    # 客服主管
    if user.dispatcher_manager?
      can :read_init, Question
      can :check, Question
      can :read_useless, Question
    end

    # 客服
    if user.dispatcher?
      can :read, Question
    end

  end
end
