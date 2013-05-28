namespace :bookings do
  desc "Expire stale bookings."
  task :expire => :environment do
    ExpireBookingsJob.new.perform
  end
end
