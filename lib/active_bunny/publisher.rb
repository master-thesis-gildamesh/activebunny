require_relative 'basics'
require_relative 'active_record/hooks'

module ActiveBunny
  class Publisher
    extend ActiveSupport::DescendantsTracker
    extend ::ActiveBunny::Basics
    extend ::ActiveBunny::ActiveRecord::Hooks

    def publish(obj, method=nil)
      method ||= caller_locations(1,1)[0].label
      ActiveBunny.publish(self.class.name, method.to_sym, obj)
    end
  end
end
