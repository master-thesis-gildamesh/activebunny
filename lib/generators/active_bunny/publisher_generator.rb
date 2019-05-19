class ActiveBunny::PublisherGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_publisher_file
    template "publisher.rb", File.join("app/publishers",class_path, "#{file_name}_publisher.rb")
  end

  def create_module_file
    return if regular_class_path.empty?
    template "module.rb", File.join("app/publishers", "#{class_path.join('/')}.rb") if behavior == :invoke
  end
end