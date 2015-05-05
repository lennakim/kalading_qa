class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # 客服
    if user.dispatcher?
      can :read, Question
    end

  end
end
