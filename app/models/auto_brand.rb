class AutoBrand < ActiveRecord::Base
  include Concerns::AutoSync
  attr_sync :name

  has_many :auto_models, dependent: :destroy, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'

  validates_presence_of :name, :internal_id

  before_save :set_name_pinyin

  def set_name_pinyin
    if name_changed?
      self.name_pinyin = PinYin.of_string(name).join(' ')
    end
    true
  end
end
