class ActiveBunny::SubscriberGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_subscriber_file
    template "subscriber.rb", File.join("app/subscribers",class_path, "#{file_name}_subscriber.rb")
  end

  def create_module_file
    return if regular_class_path.empty?
    template "module.rb", File.join("app/subscribers", "#{class_path.join('/')}.rb") if behavior == :invoke
  end
end