# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'successfully' do
    context 'create' do
      before(:each) do
        @user = create(:user)
      end
      it 'a valid user' do
        expect(@user).to be_persisted
      end
    end

    context 'invalidate' do
      it 'a user with wrong email' do
        @user = build(:user, email: FactoryBot.generate(:random_word))
        expect(@user).to_not be_valid
      end

      it 'a user with short password' do
        @user = build(:user, password: FactoryBot.generate(:random_word)[0..4])
        expect(@user).to_not be_valid
      end
    end
  end
end
