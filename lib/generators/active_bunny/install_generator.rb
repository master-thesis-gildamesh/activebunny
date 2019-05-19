class ActiveBunny::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def template_config_file
    copy_file "config.yml", "config/rabbitmq.yml"
  end
end