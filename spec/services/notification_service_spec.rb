require 'rails_helper'

describe NotificationService do
  let!(:slack_request) do
    stub_request(:post, 'https://hooks.slack.com/triggers/mdl-unit-test-endpoint')
      .with(
        body: { message: 'hiya!' },
        headers: { 'Content-Type' => 'application/json' }
      )
      .to_return(
        body: '{"ok":true}',
        headers: { 'content-type' => 'application/json' }
      )
  end

  it 'posts the given message to Slack' do
    described_class.notify('hiya!')
    expect(slack_request).to have_been_requested
  end

  context 'when there is no Slack URL available' do
    it 'makes no requests' do
      described_class.notify('hiya!', url: nil)
      expect(slack_request).to_not have_been_requested
    end
  end
end
