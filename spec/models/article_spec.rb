require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Article do
  extend ActiveRecord::AuthorizationTestHelper

  describe "in private group" do

    before(:all) do
      @group = Factory.create(:group)
      @admin = Factory.create(:admin, :stage => @group).agent
      @participant = Factory.create(:participant, :stage => @group).agent
      @observer = Factory.create(:observer, :stage => @group).agent
    end

    describe "being public" do

      before(:all) do
        @article = Factory.create(:article, :container => @group)
      end

      it_should_authorize(:admin, :read, :article)
      it_should_authorize(:admin, :update, :article)
      it_should_authorize(:admin, :delete, :article)
      it_should_authorize(:participant, :read, :article)
      it_should_authorize(:participant, :update, :article)
      it_should_not_authorize(:participant, :delete, :article)
      it_should_authorize(:observer, :read, :article)
      it_should_not_authorize(:observer, :update, :article)
      it_should_not_authorize(:observer, :delete, :article)
      it_should_authorize(Anonymous.current, :read, :article)
      it_should_not_authorize(Anonymous.current, :update, :article)
      it_should_not_authorize(Anonymous.current, :delete, :article)
    end


    describe "being private" do

      before(:all) do
        @article = Factory.create(:private_article, :container => @group)
      end

      it_should_authorize(:admin, :read, :article)
      it_should_authorize(:admin, :update, :article)
      it_should_authorize(:admin, :delete, :article)
      it_should_authorize(:participant, :read, :article)
      it_should_authorize(:participant, :update, :article)
      it_should_not_authorize(:participant, :delete, :article)
      it_should_authorize(:observer, :read, :article)
      it_should_not_authorize(:observer, :update, :article)
      it_should_not_authorize(:observer, :delete, :article)
      it_should_not_authorize(Anonymous.current, :read, :article)
      it_should_not_authorize(Anonymous.current, :update, :article)
      it_should_not_authorize(Anonymous.current, :delete, :article)
    end

  end

  describe "in public group" do

    before(:all) do
      @group = Factory.create(:public_group)
      @admin = Factory.create(:admin, :stage => @group).agent
      @participant = Factory.create(:participant, :stage => @group).agent
      @observer = Factory.create(:observer, :stage => @group).agent
    end

    describe "being public" do
      before do
        @article = Factory.create(:article, :container => @group)
      end

      it_should_authorize(:admin, :read, :article)
      it_should_authorize(:admin, :update, :article)
      it_should_authorize(:admin, :delete, :article)
      it_should_authorize(:participant, :read, :article)
      it_should_authorize(:participant, :update, :article)
      it_should_not_authorize(:participant, :delete, :article)
      it_should_authorize(:observer, :read, :article)
      it_should_not_authorize(:observer, :update, :article)
      it_should_not_authorize(:observer, :delete, :article)
      it_should_authorize(Anonymous.current, :read, :article)
      it_should_not_authorize(Anonymous.current, :update, :article)
      it_should_not_authorize(Anonymous.current, :delete, :article)
    end

    describe "being private" do

      before do
        @article = Factory.create(:private_article, :container => @group)
      end

      it_should_authorize(:admin, :read, :article)
      it_should_authorize(:admin, :update, :article)
      it_should_authorize(:admin, :delete, :article)
      it_should_authorize(:participant, :read, :article)
      it_should_authorize(:participant, :update, :article)
      it_should_not_authorize(:participant, :delete, :article)
      it_should_authorize(:observer, :read, :article)
      it_should_not_authorize(:observer, :update, :article)
      it_should_not_authorize(:observer, :delete, :article)
      it_should_not_authorize(Anonymous.current, :read, :article)
      it_should_not_authorize(Anonymous.current, :update, :article)
      it_should_not_authorize(Anonymous.current, :delete, :article)
    end

  end

  describe "in user" do

    before(:all) do
      @user = Factory.create(:user)
    end

    describe "being public" do
      before do
        @article = Factory.create(:user_article, :author => @user, :container => @user)
      end

      it_should_authorize(:user, :read, :article)
      it_should_authorize(:user, :update, :article)
      it_should_authorize(:user, :delete, :article)
      it_should_authorize(Anonymous.current, :read, :article)
      it_should_not_authorize(Anonymous.current, :update, :article)
      it_should_not_authorize(Anonymous.current, :delete, :article)
    end


    describe "being private" do

      before do
        @article = Factory.create(:private_user_article, :author => @user, :container => @user)
      end

      it_should_authorize(:user, :read, :article)
      it_should_authorize(:user, :update, :article)
      it_should_authorize(:user, :delete, :article)
      it_should_not_authorize(Anonymous.current, :read, :article)
      it_should_not_authorize(Anonymous.current, :update, :article)
      it_should_not_authorize(Anonymous.current, :delete, :article)
    end
  end

end
