require_relative 'basics'
require_relative 'active_record/hooks'

module ActiveBunny
  class Subscriber
    extend ActiveSupport::DescendantsTracker
    extend ::ActiveBunny::Basics

  end
end