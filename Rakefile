require 'bundler/gem_tasks'
require 'rdoc/task'
require 'rspec/core/rake_task'

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = 'doc'
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
end

RSpec::Core::RakeTask.new(:spec)
task default: :spec
