set :user, 'camp_czest_pl'  # Your dreamhost account's username
set :domain, 'milliken.dreamhost.com'  # Dreamhost servername where your account is located 
set :project, 'camp.czest.pl'  # Your application as its called in the repository
set :application, 'camp.czest.pl'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/home/#{user}/#{application}"  # The standard Dreamhost setup

# http://github.com/guides/deploying-with-capistrano
default_run_options[:pty] = true
set :repository,  "git://github.com/Pr0d1r2/czestcamp.git"
set :scm, "git"
set :user, "camp_czest_pl"
ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
#set :copy_remote_dir, deploy_to

role :web, domain
role :app, domain
role :db,  domain, :primary => true

# deploy config
set :deploy_to, applicationdir
#set :deploy_via,       :copy
#set :copy_strategy,    :export
#set :copy_compression, :bz2

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false


desc "Restarting after deployment"
task :after_deploy, :roles => [:app, :db, :web] do
  # If your using Capistrano, you can cleverly surpass this problem and force 'production' environment during deployment by add the following the task in your Capfile: (http://wiki.dreamhost.com/index.php/Capistrano)
  run "sed 's/# ENV\\[/ENV\\[/g' #{deploy_to}/current/config/environment.rb > #{deploy_to}/current/config/environment.temp"
  run "mv #{deploy_to}/current/config/environment.temp #{deploy_to}/current/config/environment.rb"
  # zmergowane javascripty i csski
#  run "cd #{current_path} && nohup rake RAILS_ENV=production asset:packager:build_all"
  # sharedowane katalogi odnośnie tego co w bazie
#  [ 'photos', 'avatars' ].each do |s|
#    run "cd #{current_path}/restricted && ln -s ../../../shared/restricted/#{s}"
#  end
  # sharedowane railsy
#  run "cd #{current_path}/vendor && ln -s ../../../shared/rails"
  run "cd #{current_path}/config && ln -sf #{shared_path}/config/database.yml"
  
  restart
end

task :restart do
  # zrestartuj server
  run "touch #{current_path}/public/dispatch.fcgi"  
end
