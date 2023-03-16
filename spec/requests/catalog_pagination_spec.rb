require 'rails_helper'

describe 'Catalog#index pagination' do
  let(:params) do
    {
      page: '1',
      per_page: target_per_page,
      search_field: 'all_fields',
      q: ''
    }
  end
  let(:referrer) { "https://mdl.devlocal/catalog?#{referrer_page_params}" }
  let(:headers) do
    { 'HTTP_REFERER' => referrer }
  end

  def assert_redirect(page:)
    expected_path = "/catalog?page=#{page}&per_page=#{target_per_page}&q=&search_field=all_fields"
    expect(response).to redirect_to(expected_path)
    expect(flash[:pagination_managed]).to eq(true)
  end

  before do
    get '/catalog', params: params, headers: headers
  end

  context 'from "per_page=2&page=2" to "per_page=1"' do
    let(:referrer_page_params) { 'per_page=2&page=2' }
    let(:target_per_page) { '1' }

    it 'lands you on page 3 because your offset was 3' do
      assert_redirect(page: 3)
    end
  end

  context 'from "per_page=3&page=2" to "per_page=2"' do
    let(:referrer_page_params) { 'per_page=3&page=2' }
    let(:target_per_page) { '2' }

    it 'lands you on page 2 because your offset was 4' do
      assert_redirect(page: 2)
    end
  end

  context 'from "per_page=50&page=2" to "per_page=25"' do
    let(:referrer_page_params) { 'per_page=50&page=2' }
    let(:target_per_page) { '25' }

    it 'lands you on page 3 because your offset was 51' do
      assert_redirect(page: 3)
    end
  end

  context 'from "per_page=50&page=5" to "per_page=100"' do
    let(:referrer_page_params) { 'per_page=50&page=5' }
    let(:target_per_page) { '100' }

    it 'lands you on page 3 because your offset was 201' do
      assert_redirect(page: 3)
    end
  end

  context 'from "per_page=25&page=7" to "per_page=100"' do
    let(:referrer_page_params) { 'per_page=25&page=7' }
    let(:target_per_page) { '100' }

    it 'lands you on page 2 because your offset was 151' do
      assert_redirect(page: 2)
    end
  end

  context 'from "page=5" to "per_page=100" (assumes 25 per_page default)' do
    let(:referrer_page_params) { 'page=5' }
    let(:target_per_page) { '100' }

    it 'lands you on page 2 because your offset was 101' do
      assert_redirect(page: 2)
    end
  end

  context 'from "per_page=50&page=2" to "per_page=100"' do
    let(:referrer_page_params) { 'per_page=50&page=2' }
    let(:target_per_page) { '100' }

    it 'lands you on page 1 because your offset was 51' do
      expect(response).to have_http_status(:ok)
      expect(flash.key?(:pagination_managed)).to eq(false)
    end
  end

  context 'from "per_page=50" to "per_page=100"' do
    let(:referrer_page_params) { 'per_page=50' }
    let(:target_per_page) { '100' }

    it 'lands you on page 3 because your offset was 201' do
      expect(response).to have_http_status(:ok)
      expect(flash.key?(:pagination_managed)).to eq(false)
    end
  end

  context 'from "per_page=1&page=1" to "per_page=3"' do
    let(:referrer_page_params) { 'per_page=1&page=1' }
    let(:target_per_page) { '3' }

    it 'does not redirect' do
      expect(response).to have_http_status(:ok)
      expect(flash.key?(:pagination_managed)).to eq(false)
    end
  end

  context 'when no referrer page params are provided' do
    let(:referrer_page_params) { '' }
    let(:target_per_page) { '2' }

    it 'does not redirect' do
      expect(response).to have_http_status(:ok)
      expect(flash.key?(:pagination_managed)).to eq(false)
    end
  end

  context 'referrer has no query string' do
    let(:referrer) { 'https://mdl.devlocal/' }
    let(:target_per_page) { '100' }

    it 'does not redirect' do
      expect(response).to have_http_status(:ok)
      expect(flash.key?(:pagination_managed)).to eq(false)
    end
  end

  context 'no referrer' do
    let(:target_per_page) { '25' }
    let(:headers) { {} }

    it 'does not redirect' do
      expect(response).to have_http_status(:ok)
    end
  end
end
