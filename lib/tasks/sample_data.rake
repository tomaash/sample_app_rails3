require 'faker'

# rake db:populate
namespace :db do
  desc "Fill database with sample data"
  # :environment is required so we have access to the local Rails
  # environment, including User.create!.
  task :populate => :environment do
    Rake::Task['db:reset'].invoke # clear the DB
    User.create!(:name => "Example User",
                 :email => "example@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      admin = User.create!(:name => name,
                           :email => email,
                           :password => password,
                           :password_confirmation => password)
      admin.toggle!(:admin)
    end
  end
end
