class KeywordSearchesController < ApplicationController
  before_action :set_keyword_search, only: %i[ show update destroy ]

  # GET /keyword_searches
  def index
    @keyword_searches = KeywordSearch.all

    render json: @keyword_searches
  end

  # GET /keyword_searches/1
  def show
    render json: @keyword_search
  end

  # POST /keyword_searches
  def create
    @keyword_search = KeywordSearch.new(keyword_search_params)

    if @keyword_search.save
      render json: @keyword_search, status: :created, location: @keyword_search
    else
      render json: @keyword_search.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /keyword_searches/1
  def update
    if @keyword_search.update(keyword_search_params)
      render json: @keyword_search
    else
      render json: @keyword_search.errors, status: :unprocessable_entity
    end
  end

  # DELETE /keyword_searches/1
  def destroy
    @keyword_search.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keyword_search
      @keyword_search = KeywordSearch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def keyword_search_params
      params.require(:keyword_search).permit(:keyword, :total_results, :total_links, :total_adwords, :source_code)
    end
end
