require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'faqs'" do
    it "returns http success" do
      get 'faqs'
      response.should be_success
    end
  end

  describe "GET 'guidelines'" do
    it "returns http success" do
      get 'guidelines'
      response.should be_success
    end
  end

end
