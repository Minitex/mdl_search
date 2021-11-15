require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  let(:user) { User.new }
  let(:ability) { Ability.new(user) }

  context 'with reviewer role' do
    before do
      user.user_roles = ['reviewer']
    end

    it 'can read unpublished exhibits' do
      exhibit = Spotlight::Exhibit.new(published: false)
      expect(ability).to be_able_to(:read, exhibit)
    end

    it 'can read unpublished pages' do
      page = Spotlight::Page.new(published: false)
      expect(ability).to be_able_to(:read, page)
    end

    it 'can read unpublished searches' do
      search = Spotlight::Search.new(published: false)
      expect(ability).to be_able_to(:read, search)
    end
  end
end
