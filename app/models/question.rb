class Question < ActiveRecord::Base
  include AASM

  has_many :answers, dependent: :destroy
  has_and_belongs_to_many :tags
  belongs_to :auto_brand
  belongs_to :auto_model
  belongs_to :auto_submodel
  belongs_to :customer

  aasm column: 'state' do
    state :new, initial: true
    # 无效
    state :invalid
    # 客服回答
    state :direct_answer
    # 技师抢答
    state :race
    # 专家回答
    state :fallback
    # 已解答
    state :answered
    # 已采纳
    state :adopted

    event :nullify do
      transitions from: :new, to: :invalid
    end

    event :assign_to_customer_service do
      transitions from: :new, to: :direct_answer
    end

    event :assign_to_engineer do
      transitions from: :new, to: :race
    end

    event :fall_back_on_expert do
      transitions from: :race, to: :fallback
    end

    event :answer do
      transitions from: [:direct_answer, :race, :fallback], to: :answered
    end

    event :adopt do
      transitions from: :answered, to: :adopted
    end
  end
end
