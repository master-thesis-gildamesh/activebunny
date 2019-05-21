require_relative 'basics'
require_relative 'active_record/hooks'

module ActiveBunny
  class Subscriber
    extend ActiveSupport::DescendantsTracker
    extend ::ActiveBunny::Basics

    def drop
      self.nack = true
      self.drop = true
    end

    def failure
      self.nack = true
    end
    alias error failure
    alias nack failure

    def ack?
      not self.nack
    end

    def requeue?
      not self.drop
    end
  end
end