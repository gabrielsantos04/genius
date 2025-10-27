class SearchController < ApplicationController
  def index

  end

  def search_artist
    response = SearchArtist.new(params[:query]).call

    if response.code == 200
      @results = response['response']['hits']
    else
      @results = []
      @error = "Error fetching results. Please try again."
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  private
end