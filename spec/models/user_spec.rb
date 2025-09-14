require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires email_address' do
      user = User.new(username: 'test', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include("can't be blank")
    end

    it 'requires username' do
      user = User.new(email_address: 'test@example.com', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'requires unique email_address' do
      User.create!(email_address: 'test@example.com', username: 'first', password: 'password')
      user = User.new(email_address: 'test@example.com', username: 'second', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include("has already been taken")
    end
  end

  describe 'normalizations' do
    it 'normalizes email_address to lowercase and strips whitespace' do
      user = User.create!(email_address: '  TEST@EXAMPLE.COM  ', username: 'test', password: 'password')
      expect(user.email_address).to eq('test@example.com')
    end

    it 'strips whitespace from username' do
      user = User.create!(email_address: 'test@example.com', username: '  testuser  ', password: 'password')
      expect(user.username).to eq('testuser')
    end
  end
end
