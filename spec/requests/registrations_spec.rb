# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'POST /users', type: :request do
  let(:application) { create(:doorkeeper_application) }
  let(:email) { FactoryBot.generate(:random_email) }
  let(:password) { FactoryBot.generate(:random_password) }
  let(:headers) do
    { 'Client-Id': application.uid, 'Accept': 'application/json' }
  end
  let(:params) do
    { user: { email:, password: } }
  end

  context 'successfully' do
    before do
      post(user_registration_path, params:, headers:)
      @body = JSON.parse(response.body)
      @headers = response.headers
    end

    it 'returns 200' do
      expect(response.status).to eq(201)
    end

    it 'respond with user details' do
      expect(@body['id']).to be_present
      expect(@body['email']).to eq(email)
    end

    describe 'generate credentials headers' do
      it 'includes a bearer token type' do
        expect(@headers['Token-Type']).to eq('Bearer')
      end

      it 'includes an access token' do
        expect(@headers['Access-Token']).to be_present
      end

      it 'includes expires in 2 hours' do
        hours = 2
        expect(@headers['Expires-In']).to eq(hours * 60 * 60)
      end

      it 'includes Access-Control-Expose-Headers' do
        expect(@headers['Access-Control-Expose-Headers']).to eq('Token-Type, Access-Token, Expires-In, Refresh-Token, Created-At')
      end
    end
  end

  context 'unsuccessfully' do
    context 'with wrong client id' do
      let(:headers) do
        { 'Client-Id': nil, 'Accept': 'application/json' }
      end

      before do
        post(user_registration_path, params:, headers:)
        @headers = response.headers
      end

      it 'return 200' do
        expect(response.status).to eq(201)
      end

      it 'doesn\'t generate credentials' do
        expect(@headers['Token-Type']).to_not be_present
        expect(@headers['Access-Token']).to_not be_present
        expect(@headers['Expires-In']).to_not be_present
        expect(@headers['Access-Control-Expose-Headers']).to_not be_present
      end
    end

    context 'with an invalid email' do
      let(:email) { FactoryBot.generate(:random_word) }
      let(:params) do
        { user: { email:, password: } }
      end

      before do
        post(user_registration_path, params:, headers:)
        @body = JSON.parse(response.body)
      end

      it 'return 422' do
        expect(response.status).to eq(422)
      end

      it 'respond with invalid property' do
        expect(@body['errors']['email']).to eq(['is invalid'])
      end
    end

    context 'with an invalid password' do
      let(:password) { nil }
      let(:params) do
        { user: { email:, password: } }
      end

      before do
        post(user_registration_path, params:, headers:)
        @body = JSON.parse(response.body)
      end

      it 'return 422' do
        expect(response.status).to eq(422)
      end

      context 'with a blank password' do
        it 'respond with invalid property' do
          expect(@body['errors']['password']).to eq(['can\'t be blank'])
        end
      end

      context 'with a short password' do
        let(:password) { FactoryBot.generate(:random_word)[0..4] }
        let(:params) do
          { user: { email:, password: } }
        end

        before do
          post(user_registration_path, params:, headers:)
          @body = JSON.parse(response.body)
        end

        it 'respond with invalid property' do
          expect(@body['errors']['password']).to eq(['is too short (minimum is 6 characters)'])
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
