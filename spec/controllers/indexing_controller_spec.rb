require 'rails_helper'

describe IndexingController do
  describe 'POST to #create' do
    let(:params) do
      {
        collection: 'pokemon',
        date: date
      }
    end
    let(:etl) { instance_double(MDL::ETL) }

    before do
      user = User.create!(
        email: 'fred@example.com',
        password: 'password',
        user_roles: ['admin']
      )
      sign_in user
      allow(MDL::ETL).to receive(:new).and_return(etl)
    end

    context 'when a date is provided' do
      let(:date) { '2022-01-03' }

      it 'forwards the date to the ETL' do
        expect(etl).to receive(:run).with(
          set_specs: ['pokemon'],
          from: date
        )
        post :create, params: params
      end
    end

    context 'when no date is provided' do
      let(:date) { '' }

      it 'forwards a default date to the ETL' do
        expect(etl).to receive(:run).with(
          set_specs: ['pokemon'],
          from: '1970-01-01'
        )
        post :create, params: params
      end
    end
  end
end
