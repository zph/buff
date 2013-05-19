require "bundler/gem_tasks"
require 'rake'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec_*.rb']
  t.options = '-v'
end

task :default  => :spec

task :curl_dump, [ :url ] do |t, args|
  access_token = `cat ~/.bufferapprc | head -3 | tail -1`.chomp
  sh "curl -is #{args[:url]}?access_token=#{access_token}"
end
