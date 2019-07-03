module ActiveBunny
  module ActiveModel
    module Hooks

      def create_model_hooks(except:[], only:nil)
        return unless ActiveBunny.run?
        hooks = (only || [:after_create, :after_update, :after_destroy]) - except
        caller_class = self
        model_name = self.send(:class_name)
        model_class = model_name.constantize

        hooks.each do |hook|
          method_name = "#{hook}".sub("after_", '')
          if model_class.respond_to? hook
            caller_class.define_method("#{method_name}") do |record|
              self.publish(record.to_json, method_name)
            end

            model_class.send(hook, Proc.new {|record| caller_class.new.send(method_name, record)})
          end
        end
      end
    end
  end
end