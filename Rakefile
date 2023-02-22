# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

desc 'Run rubocop linter'
task :rubocop do
  RuboCop::RakeTask.new do |task|
    task.requires << 'rubocop-rake'
  end
end

task default: ['test:default']

namespace :test do
  desc 'Run inspec check for this extension'
  task :check do
    cwd = File.join(File.dirname(__FILE__))
    sh("bundle exec inspec check #{cwd} --chef-license=accept-silent")
  end

  desc 'Run default inspec integration tests'
  task :default do
    cwd = File.join(File.dirname(__FILE__))
    sh("bundle exec inspec exec #{cwd}/test/integration/default --chef-license=accept-silent")
  end
end

desc 'Perform linting and run integration tests'
task :all do
  Rake::Task['rubocop'].execute
  Rake::Task['test:check'].execute
  Rake::Task['test:default'].execute
end
