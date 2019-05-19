require 'test_helper'
puts(Dir.pwd)
require_relative "#{File.join(Dir.pwd, "lib", "generators", "active_bunny", "publisher_generator.rb")}"
require_relative "#{File.join(Dir.pwd, "lib", "generators", "active_bunny", "subscriber_generator.rb")}"

class ActiveBunny::Test < ActiveSupport::TestCase


  publisher_generator = ActiveBunny::PublisherGenerator
  subscriber_generator = ActiveBunny::SubscriberGenerator

  dummy_app = Dummy::Application
  dummy_assets = dummy_app.assets
  dummy_app_root = File.expand_path('./dummy', __dir__)

  setup do
    dummy_app.initialize! unless dummy_app.initialized?
    publisher_generator.start(["user"], destination_root: dummy_app_root)
    subscriber_generator.start(["user"], destination_root: dummy_app_root)
  end

  teardown do
    File.delete File.join dummy_app_root, "app/publishers/user_publisher.rb"
    File.delete File.join dummy_app_root, "app/subscribers/user_subscriber.rb"
  end

  test "truth" do
    assert_kind_of Module, ActiveBunny
  end

  test "test_generators" do
    assert(File.exists? File.join dummy_app_root, "app/publishers/user_publisher.rb")
    assert(File.exists? File.join dummy_app_root, "app/subscribers/user_subscriber.rb")
  end
end
