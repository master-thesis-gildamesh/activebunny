module ActiveBunny
  module Basics

    def reload
      if self < ActiveBunny::Subscriber
        reload_subscriber
      elsif self < ActiveBunny::Publisher
        reload_publisher
      end
    end

    private
    def reload_subscriber
      if Rails.const_defined? 'Server'
        ActiveBunny.channel(self.name)
        ActiveBunny.create_queues(self.name, class_name, method_list(ActiveBunny::Subscriber))
      end
    end

    def reload_publisher
      ActiveBunny.channel(self.name)
      ActiveBunny.create_fanouts(self.name, class_name, method_list(ActiveBunny::Publisher))
    end

    def method_list(parent)
      @method_list ||= (self.instance_methods - parent.instance_methods)
    end

    def class_name()
      if @class_name.nil?
        @class_name = self.name || ""
        @class_name&.slice! "Subscriber"
        @class_name&.slice! "Publisher"
        @class_name.gsub("::", ".")
        @class_name = "Default" if @class_name&.empty?
      end
      @class_name
    end
  end
end
