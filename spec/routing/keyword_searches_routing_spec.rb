require "rails_helper"

RSpec.describe KeywordSearchesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/keyword_searches").to route_to("keyword_searches#index")
    end

    it "routes to #show" do
      expect(get: "/keyword_searches/1").to route_to("keyword_searches#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/keyword_searches").to route_to("keyword_searches#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/keyword_searches/1").to route_to("keyword_searches#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/keyword_searches/1").to route_to("keyword_searches#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/keyword_searches/1").to route_to("keyword_searches#destroy", id: "1")
    end
  end
end
