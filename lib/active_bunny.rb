require "active_support"
require 'bunny'

module ActiveBunny
  extend ActiveSupport::Autoload

  autoload :Publisher
  autoload :Subscriber

  @@conn = nil
  @@config = {}
  @@channel = {}
  @@fanouts = {}
  @@queues = {}

  def self.config
    @@config
  end

  def self.config= (config)
    @@config = {
        logger: Rails.logger,
        auth_mechanism: "plain",
        username: "guest",
        password: "guest",
        host: "127.0.0.1",
        port: "5672",
        virtual_host: "/"
    }.merge(config)
    @@config[:auth_mechanism] = @@config[:auth_mechanism].upcase
  end

  def self.connection
    unless @@conn
      c = self.config
      @@conn = Bunny.new **c
      @@conn.start
    end
    @@conn
  end

  def self.channel(name)
    @@channel[name] ||= self.connection.create_channel
  end

  def self.create_queues(name, simple_name, method_list)
    @@queues[name] ||= {}
    queues = @@queues[name]
    (queues.keys - method_list.map(&:to_sym)).each do |m|
      queues.except!(m)
    end
    (method_list.map(&:to_sym) - queues.keys).each do |m|
      queues[m] = channel(name).queue("#{Rails.application.class.name.deconstantize}.#{simple_name}.#{m}", durable: true, auto_delete: true)
      queues[m].bind("#{simple_name}.#{m}")
      queues[m].subscribe do |delivery_info, properties, payload|
        name.constantize.new.send(m, payload)
      end
    end
  end

  def self.create_fanouts(name, simple_name, method_list)
    method_list << "default"

    @@fanouts[name] ||= {}
    fanouts = @@fanouts[name]
    (fanouts.keys - method_list.map(&:to_sym)).each do |m|
      fanouts.except!(m)
    end
    (method_list.map(&:to_sym) - fanouts.keys).each do |m|
      fanouts[m] = channel(name).fanout("#{simple_name}.#{m}", durable: true, auto_delete: true)
    end
  end

  def self.fanouts(name)
    @@fanouts[name]
  end

  def self.fanout(name, method)
    self.fanouts(name)[method] || self.fanouts(name)[:default]
  end

  def self.publish(name, method, payload)
    self.fanout(name, method).publish(payload)
  end


  at_exit do
    @@conn.close
  end
end

require "active_bunny/railtie" if defined?(Rails.application)