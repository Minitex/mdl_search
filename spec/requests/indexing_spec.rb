require 'rails_helper'

describe 'self-service indexing' do
  it 'is available to admins' do
    user = create(:user, :admin)
    sign_in(user)
    get '/indexing'

    expect(response).to have_http_status(:ok)
  end

  it 'is not available to non-admins' do
    user = create(:user)
    sign_in(user)
    get '/indexing'

    expect(response).to have_http_status(:found)
  end
end
