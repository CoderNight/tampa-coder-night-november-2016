require 'rails_helper'

RSpec.describe "SocialNodes", type: :request do
  describe "GET /social_nodes" do
    it "works! (now write some real specs)" do
      get social_nodes_path
      expect(response).to have_http_status(200)
    end
  end
end
