
DEPLOY_TO = '/home/deploy/photo'
CURRENT = "#{DEPLOY_TO}/current"
UNICORN_PID = "#{DEPLOY_TO}/shared/pids/unicorn.pid"
# Preload application code before forking worker processes.
preload_app true
worker_processes 2

timeout 1600

# Location of the socket, to appear in an NGINX upstream configuration
listen "#{DEPLOY_TO}/shared/unicorn.socket", backlog: 64

# Where to store the pid file for the server process.
pid UNICORN_PID
stderr_path "#{DEPLOY_TO}/shared/log/unicorn.stderr.log"
stdout_path "#{DEPLOY_TO}/shared/log/unicorn.stdout.log"


ENV['BUNDLE_GEMFILE'] = File.join(CURRENT, 'Gemfile')

if GC.respond_to? :copy_on_write_friendly=
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  # When the signal is sent to the old server process to start up a new
  # master process with the new code release, the old server's pidfile
  # is suffixed with ".oldbin".


  old_pid = "#{UNICORN_PID}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # already shut down
    end
  end
end
