require 'rails_helper'

describe '/widget', type: :request do
  let(:account) { create(:account) }
  let(:web_widget) { create(:channel_widget) }
  let(:contact) { create(:contact, account: account) }
  let(:contact_inbox) { create(:contact_inbox, contact: contact, inbox: web_widget.inbox) }
  let(:payload) { { source_id: contact_inbox.source_id, inbox_id: web_widget.inbox.id } }
  let(:token) { ::Widget::TokenService.new(payload: payload).generate_token }

  describe 'GET /widget' do
    it 'renders the page correctly when called with website_token' do
      get widget_url(website_token: web_widget.website_token)
      expect(response).to be_successful
      expect(response.body).not_to include(token)
    end

    it 'renders the page correctly when called with website_token and cw_conversation' do
      get widget_url(website_token: web_widget.website_token, cw_conversation: token)
      expect(response).to be_successful
      expect(response.body).to include(token)
    end

    it 'returns 404 when called with out website_token' do
      get widget_url
      expect(response.status).to eq(404)
    end
  end
end
