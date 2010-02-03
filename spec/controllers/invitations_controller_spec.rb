require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvitationsController do
  include ActionController::AuthenticationTestHelper

  integrate_views

  before(:all) do
    @group = Factory(:group)
    @admin = Factory(:admin, :stage => @group).agent
    @participant = Factory(:participant, :stage => @group).agent
    @observer = Factory(:observer, :stage => @group).agent
  end

  describe "as admin" do

    before do
      login_as(@admin)

      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    describe "POST new" do
      it "creates new Invitation" do
        post :create, :group_id => @group.id,
                      :invitation => Factory.attributes_for(:invitation)
        response.should be_redirect
        assigns[:invitation].should be_valid
        assigns[:invitation].introducer.should == @admin
        ActionMailer::Base.deliveries.size.should == 1
        ActionMailer::Base.deliveries.first.body.should =~
          /#{ assigns[:invitation].comment }/
      end

    end

  end

  describe "accepting invitation" do
    describe "without candidate" do
      before do
        @invitation = Factory.create(:invitation, :candidate => nil)
      end

      it "should render" do
        get :show, :id => @invitation.code
        response.should be_success
      end

      describe "and registering" do

        it "creates and includes her in the group" do
          post :update, :id => @invitation.code,
                        :invitation => { :processed => true,
                                         :accepted => true },
                        :user => { :login => "Invited User",
                                   :password => "invitation_test",
                                   :password_confirmation => "invitation_test" }
          assigns[:invitation].should be_valid
          assigns[:invitation].state.should == :accepted

          assert authenticated?
          assert current_agent.email.should == @invitation.email

          assert @invitation.group.users.include? current_agent
        end

      end


    end

    describe "with candidate" do
      before do
        @invitation = Factory.create(:invitation, :email => nil)
      end

      it "should redirect the user to sessions/new" do
        get :show, :id => @invitation.code, :format => 'html'
        response.should redirect_to(new_session_url)
      end

      describe "authenticated" do
        before do
          login_as @invitation.candidate
        end

        it "should render" do
          get :show, :id => @invitation.code
          assigns[:invitation].should == @invitation
          assert_response 200
        end

        it "creates and includes her in the group" do
          post :update, :id => @invitation.code,
                        :invitation => { :processed => true,
                                         :accepted => true }
          assigns[:invitation].should be_valid
          assigns[:invitation].state.should == :accepted

          assert current_agent.email.should == @invitation.email

          assert @invitation.group.users.include? current_agent
        end

      end
    end
  end
end
