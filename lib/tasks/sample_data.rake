require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
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
  end
end