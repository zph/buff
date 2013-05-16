require "bundler/gem_tasks"
require 'rake'

task :curl_dump, [ :url ] do |t, args|
  access_token = `cat ~/.bufferapprc | head -3 | tail -1`.chomp
  sh "curl -is #{args[:url]}?access_token=#{access_token}"
end
