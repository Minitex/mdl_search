require 'rails_helper'
require 'cancan/matchers'

describe User do
  describe 'authorization' do
    subject(:ability) { Ability.new(user) }

    context 'without roles' do
      let(:user) { User.new }
      it { is_expected.to_not be_able_to(:index, :collections) }
    end

    context 'with admin role' do
      let(:user) do
        User.new.tap { |u| u.user_roles = ['admin'] }
      end

      it { is_expected.to be_able_to(:index, :collections) }
    end
  end
end
