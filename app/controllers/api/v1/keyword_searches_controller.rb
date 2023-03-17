# frozen_string_literal: true

require 'sidekiq/api'

module Api
  module V1
    # Read and create keyword searches
    class KeywordSearchesController < ApplicationController
      before_action :doorkeeper_authorize!
      respond_to :json

      # GET /keyword_searches
      def index
        @keyword_searches = KeywordSearch
                            .select(:id, :keyword, :total_results, :total_adwords, :total_links, :created_at)
                            .all
                            .offset(params[:offset])
                            .limit(params[:limit])
                            .order('id desc')

        respond_with @keyword_searches
      end

      # GET /keyword_searches/1
      def show
        render json: @keyword_search
      end

      # POST /keyword_searches
      def create
        MassSearchJob.perform_async(keyword_search_params[:keywords])

        render json: {}, status: :created
      end

      # GET /active_processes
      def active_processes
        worker_set = Sidekiq::WorkSet.new
        render json: { size: worker_set.size }, status: :ok
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_keyword_search
        @keyword_search = KeywordSearch.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def keyword_search_params
        params.require(:keyword_search).permit(keywords: [])
      end
    end
  end
end
