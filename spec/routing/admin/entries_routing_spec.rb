require "spec_helper"

describe Admin::EntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/entries").should route_to("admin/entries#index")
    end

    it "routes to #new" do
      get("/admin/entries/new").should route_to("admin/entries#new")
    end

    it "routes to #show" do
      get("/admin/entries/1").should route_to("admin/entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/entries/1/edit").should route_to("admin/entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/entries").should route_to("admin/entries#create")
    end

    it "routes to #update" do
      put("/admin/entries/1").should route_to("admin/entries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/entries/1").should route_to("admin/entries#destroy", :id => "1")
    end

  end
end
