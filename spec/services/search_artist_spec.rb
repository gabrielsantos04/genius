# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchArtist do
  describe '#call' do
    let(:query) { 'Adele' }
    let(:service) { described_class.new(query) }
    let(:api_url) { "https://api.genius.com/search?q=#{query}" }
    let(:headers) { { "Authorization" => "Bearer #{ENV['TOKEN']}" } }

    before do
      allow(ENV).to receive(:[]).with('TOKEN').and_return('test_token')
      allow(HTTParty).to receive(:get).with("#{api_url}", headers: headers).and_return(double('response'))
    end

    it "makes a GET request to the Genius API with the correct URL and headers" do
      service.call

      expect(HTTParty).to have_received(:get).with("#{api_url}", headers: headers)
    end
  end
end
