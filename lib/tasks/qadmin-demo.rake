namespace :qadmin-demo do
  task :load_env => [:environment]
  
  namespace :clean do
    desc 'Nightly maitenence task for qadmin-demo'
    task :nightly => ['qadmin-demo:load_env', 'db:clear_sessions'] do
      
    end
  end
end
