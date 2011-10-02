# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

#======================================
# rake db:migrate ===> cuses error:  ==> "uninitialized constant Rake::DSL"
# solution was to add the following line to this rake file above require 'rake'.
require 'rake/dsl_definition'
#======================================

require 'rake'

SampleApp::Application.load_tasks
