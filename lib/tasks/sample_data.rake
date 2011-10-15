# Moved  the following line to where it is after "task :populate => :environment do"
# to sovle "heroku rake db:migrate" issue.
#require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    adnin = User.create!(:name => "Example User",
                                    :email => "example@railstutorial.org",
                                    :password => "foobar",
                                    :password_confirmation => "foobar")
    adnin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "xxxxxx"
      User.create!(:name => name,
                          :email => email,
                          :password => password,
                          :password_confirmation => password)
    end
    
    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentences(5))
      end
    end
  end
end