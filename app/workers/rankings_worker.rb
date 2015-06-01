class RankingsWorker
  include Sidekiq::Worker
  include WorkersHelper

  def perform(store_name, store_rss_name, ranking_group_name, ranking_group_itunes_name, ranking_group_genre)
    get_rankings(store_name, store_rss_name, ranking_group_name, ranking_group_itunes_name, ranking_group_genre)
  end
end
