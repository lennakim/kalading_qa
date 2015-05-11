class Question < ActiveRecord::Base
  include AASM

  serialize :images, JSON
  mount_uploaders :images, ImageUploader

  has_many :answers, dependent: :destroy
  has_many :question_assignments, dependent: :destroy
  has_and_belongs_to_many :tags
  belongs_to :auto_brand, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'
  belongs_to :auto_model, foreign_key: 'auto_model_internal_id', primary_key: 'internal_id'
  belongs_to :auto_submodel, foreign_key: 'auto_submodel_internal_id', primary_key: 'internal_id'
  belongs_to :customer

  validates_presence_of :auto_submodel_internal_id, :customer_id, :content, :state

  aasm column: 'state' do
    state :init, initial: true
    # 无效
    state :useless
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
      transitions from: :init, to: :useless
    end

    event :assign_to_dispatcher do
      transitions from: :init, to: :direct_answer do
        after do |dispatcher_id|
          create_dispatcher_assignment!(dispatcher_id)
        end
      end
    end

    event :assign_to_engineer do
      transitions from: :init, to: :race
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

  def create_dispatcher_assignment!(dispatcher_id)
    question_assignments.create!(
      user_internal_id: dispatcher_id,
      user_role: 'dispatcher'
    )
  end
end
