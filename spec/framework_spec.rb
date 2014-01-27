describe "RSpec.configuration.mock_framework.framework_name" do
  it "returns :mocha" do
    RSpec.configuration.mock_framework.framework_name.should eq(:mocha)
  end
end