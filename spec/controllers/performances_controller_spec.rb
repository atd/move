require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PerformancesController do
  include ActionController::AuthenticationTestHelper

  integrate_views

  before(:all) do
    @group = Factory(:group)
    @admin = Factory(:admin, :stage => @group).agent
    @participant = Factory(:participant, :stage => @group).agent
    @observer = Factory(:observer, :stage => @group).agent
  end

  describe "as admin" do

    before(:each) do
      login_as(@admin)
    end

    describe "GET index" do
      it "exposes all performances as @performances" do
        get :index, :group_id => @group.id
        response.should be_success
        assigns[:performances].should == @group.stage_performances
      end

    end

  end

end
