namespace :db do
  desc 'Clear data from Comment table'
  task clear_data: :environment do
    Comment.delete_all
  end
end
