require 'rake'
require 'spec/rake/spectask'
require 'yard'
require 'yard/rake/yardoc_task'

desc "Run all the specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*spec.rb']
end

desc "Generate the documentation using YARD"
YARD::Rake::YardocTask.new('doc') do |t|
  t.files   = ['lib/**/*.rb'] 
end
