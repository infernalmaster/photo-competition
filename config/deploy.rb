require 'bundler/capistrano'
set :application, "photo"

# настройка системы контроля версий и репозитария, по умолчанию - git, если используется иная система версий, нужно изменить значение scm
set :scm, :git
set :deploy_via, :remote_cache
set :repository,  "https://github.com/infernalmaster/photo-competition.git"

set :user, "hosting_syzspectroom"
set :use_sudo, false
set :deploy_to, "/home/hosting_syzspectroom/projects/photo"


role :web, "hydrogen.locum.ru"   # Your HTTP server, Apache/etc
role :app, "hydrogen.locum.ru"   # This may be the same as your `Web` server
role :db,  "hydrogen.locum.ru", :primary => true # This is where Rails migrations will run


set :bundle_without,  [:development, :test]
set :rvm_ruby_string, "2.1.5"
set :bundle_cmd,      "rvm use #{rvm_ruby_string} do bundle"
set :bundle_dir,      File.join(fetch(:shared_path), 'gems')

set :unicorn, "/var/lib/gems/1.8/bin/unicorn"
set :unicorn_conf, "/etc/unicorn/photo.syzspectroom.rb"
set :unicorn_pid, "/var/run/unicorn/hosting_syzspectroom/photo.syzspectroom.pid"

set :unicorn_start_cmd, "(cd #{deploy_to}/current; rvm use #{rvm_ruby_string} do bundle exec unicorn -E production -Dc #{unicorn_conf})"

set :shared_children, shared_children + %w{public/uploads}

task :copy_db, roles => :app do
  app_db = "#{shared_path}/production.db"
  run "ln -s #{app_db} #{release_path}/production.db"
end
task :copy_settings, roles => :app do
  app_db = "#{shared_path}/settings.rb"
  run "ln -s #{app_db} #{release_path}/settings.rb"
end
after "deploy:update_code", :copy_db, :copy_settings

# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run unicorn_start_cmd
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
  end
end

desc "Use datamapper to call autoupgrade instead of db:migrate."
task :migrate, :roles => :app do
 run "cd #{deploy_to}/current; rvm use #{rvm_ruby_string} do bundle exec rake db:migrate RACK_ENV=production"
end
