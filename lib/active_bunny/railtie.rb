require "rails"
require 'active_bunny/publisher'
require 'active_bunny/subscriber'

module Rails
  module ActiveBunny
    class Railtie < Rails::Railtie

      if Rails.const_defined? 'Console' or Rails.const_defined? 'Server'

        config.active_bunny = ::ActiveBunny

        initializer "activebunny.load-config" do
          if config.active_bunny.run?
            config.active_bunny.load_config("#{Rails.root}/config/rabbitmq.yml")
          end
        end

        initializer "activebunny.file_watcher" do |app|
          if config.active_bunny.run?
            app.reloaders << ActiveSupport::FileUpdateChecker.new([], { "app/subscribers" => [".rb"], "app/publishers" => [".rb"] }) do
              puts "Active Bunny reloading..."
            end
          end
        end

        initializer "activebunny.connect_to_rabbitmq" do |app|
          if config.active_bunny.run?
            config.active_bunny.connection
          end
        end

        ActiveSupport::Reloader.to_prepare do
          Railtie.load_stuff
          ::ActiveBunny::Publisher.descendants.each do |child|
            child.send(:reload)
          end
          ::ActiveBunny::Subscriber.descendants.each do |child|
            child.send(:reload)
          end
        end

        def self.load_stuff
          if config.active_bunny.run?
            Dir.glob(File.join(Rails.root, 'app', 'publishers', '**', '*.rb'), &method(:require_dependency))
            Dir.glob(File.join(Rails.root, 'app', 'subscribers', '**', '*.rb'), &method(:require_dependency))
          end
        end
      end
    end
  end
end
