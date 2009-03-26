require 'rake'
require 'spec/rake/spectask'
require 'yard'
require 'yard/rake/yardoc_task'
require File.dirname(__FILE__) + "/lib/recurring_events"

desc "Run all the specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/']
end

desc "Generate the documentation using YARD"
YARD::Rake::YardocTask.new('doc') do |t|
  t.files   = ['lib/**/*.rb'] 
end

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
end

desc "Load the names file into the database"
task :load_names do
  f = File.open(File.dirname(__FILE__) + "/db/names")
  names = f.readlines.map { |name| name.rstrip.downcase }
  db = Corpus.new
  names.each { |name| db[name] = :name}
end
