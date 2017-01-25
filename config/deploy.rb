require "bundler/capistrano"


set :application, "photo"
set :repository,  "https://github.com/infernalmaster/photo-competition.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "178.62.231.23"                          # Your HTTP server, Apache/etc
role :app, "178.62.231.23"                          # This may be the same as your `Web` server
role :db,  "178.62.231.23", :primary => true # This is where Rails migrations will run

set :user, 'deploy'
set :use_sudo, false
set :bundle_without,  [:development, :test]
set :bundle_dir,      File.join(fetch(:shared_path), 'gems')

set :deploy_to, '/home/deploy/photo'
set :unicorn_conf, "#{deploy_to}/current/config/deploy.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :unicorn_start_cmd, "(cd #{deploy_to}/current; bundle exec unicorn -E production -Dc #{unicorn_conf})"

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

set :shared_children, shared_children + %w{public/uploads}

task :copy_db, roles => :app do
  app_db = "#{shared_path}/production.db"
  run "ln -s #{app_db} #{release_path}/production.db"
end
task :copy_settings, roles => :app do
  app_db = "#{shared_path}/settings.rb"
  run "ln -sf #{app_db} #{release_path}/settings.rb"
end
after "deploy:update_code", :copy_settings

set (:bundle_cmd) { "#{release_path}/bin/bundle" }
set :bundle_flags, "--deployment --quiet --binstubs"


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
 run "cd #{deploy_to}/current; bundle exec rake db:migrate RACK_ENV=production"
end


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
