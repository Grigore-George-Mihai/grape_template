# frozen_string_literal: true

module Pg
  class ClearQueryStatsJob
    include Sidekiq::Job

    def perform
      Rake::Task.clear
      Rails.application.load_tasks
      Rake::Task["pghero:clean_query_stats"].invoke
    end
  end
end
