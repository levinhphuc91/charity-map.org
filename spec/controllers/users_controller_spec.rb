require 'spec_helper'

describe UsersController do

  it "stores receipt after the SMS API is being pulled" do
    get 'verification_delivery_receipt'
    response.body.should == "Error."
  end

  it "should update receipt" do
    user = FactoryGirl.create :user
    user.update_attributes :phone => "0933250591"
    verification = FactoryGirl.create :verification
    verification.update_attributes :user_id => user.id
    returned_params = Rack::Utils.parse_nested_query "msisdn=66837000111&to=84933250591&network-code=52099&messageId=000000FFFB0356D2&price=0.02000000&status=delivered&scts=1208121359&err-code=0&message-timestamp=2012-08-12+13%3A59%3A37"
    get 'verification_delivery_receipt', :params => returned_params
    verification.receipt.should_not == nil
    response.body.should == "Confirmed."
  end
end
