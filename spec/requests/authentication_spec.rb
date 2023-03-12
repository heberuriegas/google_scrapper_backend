# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'POST /oauth/token', type: :request do
  let(:application) { create(:doorkeeper_application) }
  let(:password) { FactoryBot.generate(:random_password) }
  let(:user) { create(:user, password:) }

  context 'successfully' do
    let(:params) do
      {
        client_id: application.uid,
        grant_type: 'password',
        email: user.email,
        password:
      }
    end

    before do
      post(oauth_token_path, params:)
      @body = JSON.parse(response.body)
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'generate a bearer token' do
      expect(@body['token_type']).to eq('Bearer')
    end

    it 'respond with an access token' do
      expect(@body['access_token']).to be_present
    end

    it 'expires in 2 hours' do
      hours = 2
      expect(@body['expires_in']).to eq(hours * 60 * 60)
    end
  end

  context 'unsuccessfully' do
    context 'with wrong client id' do
      let(:params) do
        {
          client_id: nil,
          grant_type: 'password',
          email: user.email,
          password:
        }
      end

      before do
        post(oauth_token_path, params:)
        @body = JSON.parse(response.body)
      end

      it 'respond with unauthorized' do
        expect(response.status).to eq(401)
      end

      it 'respond with error' do
        expect(@body['error']).to eq('invalid_client')
      end
    end

    context 'with wrong credentials' do
      let(:params) do
        {
          client_id: application.uid,
          grant_type: 'password',
          email: user.email,
          password: FactoryBot.generate(:random_word)
        }
      end

      before do
        post(oauth_token_path, params:)
        @body = JSON.parse(response.body)
      end

      it 'respond with unauthorized' do
        expect(response.status).to eq(400)
      end

      it 'respond with error' do
        expect(@body['error']).to eq('invalid_grant')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
