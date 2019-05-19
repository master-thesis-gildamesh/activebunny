require "rails"
require 'active_bunny/publisher'
require 'active_bunny/subscriber'

module Rails
  module ActiveBunny
    class Railtie < Rails::Railtie

      config.active_bunny = ::ActiveBunny

      initializer "activebunny.load-config" do
        if File.exists?(File.join(Rails.root, 'config', 'rabbitmq.yml'))
          config.active_bunny.config = YAML.load_file("#{Rails.root}/config/rabbitmq.yml").deep_symbolize_keys[Rails.env.to_sym]
        end
      end

      initializer "activebunny.file_watcher" do |app|
        if File.exists?(File.join(Rails.root, 'config', 'rabbitmq.yml'))
          app.reloaders << ActiveSupport::FileUpdateChecker.new([], { "app/subscribers" => [".rb"], "app/publishers" => [".rb"] }) do
            puts "Active Bunny reloading..."
          end
        end
      end

      initializer "activebunny.connect_to_rabbitmq" do |app|
        if File.exists?(File.join(Rails.root, 'config', 'rabbitmq.yml'))
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
        if File.exists?(File.join(Rails.root, 'config', 'rabbitmq.yml'))
          Dir.glob(File.join(Rails.root, 'app', 'publishers', '**', '*.rb'), &method(:require_dependency))
          Dir.glob(File.join(Rails.root, 'app', 'subscribers', '**', '*.rb'), &method(:require_dependency))
        end
      end
    end
  end
end
