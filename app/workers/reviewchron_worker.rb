class ReviewchronWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(3, 9, 15, 21) }
  # recurrence{ minutely(1) }
  def perform
    App.find_each do |app|
      if app.followers.count > 0
        if hours_elapsed_since(app.last_scraped.to_s) > app.updatefreqhrs
        	logger.info "Launching review update (RSS) worker for App: #{app.name}."
          UpdatereviewsWorker.perform_async(app.id)
        end
      end
    end
  end

  def hours_elapsed_since(datestring)
    datestring = (DateTime.now - 1.day) if datestring.nil? || datestring.empty?
    (Time.parse(DateTime.now.to_s) - Time.parse(datestring.to_s))/1.hour
  end
end

