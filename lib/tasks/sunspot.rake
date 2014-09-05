namespace :sunspot do
  namespace :solr do
    desc "Force restart the solr server"
    task :force_restart do
      begin
        Rake::Task["sunspot:solr:stop"].execute
      rescue
        puts 'Failed to stop solr, not running?'
      end
      Rake::Task["sunspot:solr:start"].execute
    end
  end
end
