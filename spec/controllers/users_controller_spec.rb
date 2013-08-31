require 'spec_helper'

describe UsersController do
  
  describe "GET 'dashboard'" do
    it "returns http !success" do
      get 'dashboard'
      response.should_not be_success
    end
  end

  describe "GET 'profile'" do
    it "returns http !success" do
      get 'profile'
      response.should_not be_success
    end
  end

  describe "GET 'settings'" do
    it "returns http !success" do
      get 'settings'
      response.should_not be_success
    end
  end

end
