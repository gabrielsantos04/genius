class SearchArtist
  URI = 'https://api.genius.com/search?q='
  def initialize(query)
    @query = query
  end

  def call
    search
  end

  private

  def search
    HTTParty.get("#{URI}#{@query}", headers: { "Authorization" => "Bearer #{ENV['TOKEN']}" })
  end
end