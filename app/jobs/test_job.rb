# TODO: delete me
class TestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.first.touch
  end
end
