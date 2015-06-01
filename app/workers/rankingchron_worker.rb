class RankingchronWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  include WorkersHelper

  recurrence { daily.hour_of_day(0,2,4,6,8,10,12,14,16,18,20,22) }
  # recurrence { minutely(1) }

  def perform
    STORES.sort_by { |a| a[:name] }.each do |store|
      logger.info "Kicking off rankings fetch for #{store[:name]} Store at Time: #{Time.now}."
      RANKING_GROUPS.each do | ranking_group |
        logger.info "Kicking off rankings fetch for #{ranking_group[:name]} Ranking Group at Time: #{Time.now}."
        RankingsWorker.perform_async(store[:name], store[:rss_name], ranking_group[:name], ranking_group[:itunes_name], ranking_group[:genre_id])
      end
    end
  end
end