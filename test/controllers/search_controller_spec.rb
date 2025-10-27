# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search_artist' do
    let(:valid_query) { 'Adele' }
    let(:result) do
      {
        'response' => {
          'hits' => [
            { 'result' => { 'title' => 'Music 1' } },
            { 'result' => { 'title' => 'Music 2' } }
          ]
        }
      }
    end
    let(:response_received) { instance_double('Response', code: 200, body: result) }

    context 'when api works' do
      before do
        allow(response_received).to receive(:[]).with('response').and_return(result['response'])
        allow_any_instance_of(SearchArtist).to receive(:call).and_return(response_received)
      end

      it 'returns a successful response and assigns results' do
        get :search_artist, params: { query: valid_query }, format: :turbo_stream

        expect(response).to have_http_status(:success)
        expect(assigns(:results)).not_to be_empty
        expect(assigns(:error)).to be_nil
        expect(assigns(:results).size).to eq(2)
      end
    end

    context 'when api fails' do
      let(:error_response) { instance_double('Response', code: 500) }

      before do
        allow_any_instance_of(SearchArtist).to receive(:call).and_return(error_response)
      end

      it 'handles the error and assigns an error message' do
        get :search_artist, params: { query: valid_query }, format: :turbo_stream

        expect(response).to have_http_status(:success)
        expect(assigns(:results)).to be_empty
        expect(assigns(:error)).to eq("Error fetching results. Please try again.")
      end
    end
  end
end
