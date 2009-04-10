require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Article do
  extend ActiveRecord::AuthorizationTestHelper

  describe "in private group" do

    before(:all) do
      @article = Factory(:article)
      @container = @article.container
      @admin = Factory(:admin, :group => @container).member
      @participant = Factory(:participant, :group => @container).member
    end

    it_should_authorize(:admin, :read, :article)
    it_should_authorize(:admin, :update, :article)
    it_should_authorize(:admin, :delete, :article)
    it_should_authorize(:participant, :read, :article)
    it_should_authorize(:participant, :update, :article)
    it_should_authorize(:participant, :delete, :article)
    it_should_authorize(Anonymous.current, :read, :article)
    it_should_not_authorize(Anonymous.current, :update, :article)
    it_should_not_authorize(Anonymous.current, :delete, :article)

    describe "with private article" do

      before(:all) do
        @article.update_attribute :public_read, false
      end

      it_should_authorize(:admin, :read, :article)
      it_should_authorize(:admin, :update, :article)
      it_should_authorize(:admin, :delete, :article)
      it_should_authorize(:participant, :read, :article)
      it_should_authorize(:participant, :update, :article)
      it_should_authorize(:participant, :delete, :article)
      it_should_not_authorize(Anonymous.current, :read, :article)
      it_should_not_authorize(Anonymous.current, :update, :article)
      it_should_not_authorize(Anonymous.current, :delete, :article)
    end

  end

  describe "in public group" do

    before(:all) do
      @article = Factory(:article)
      @container = @article.container
      @container.update_attribute(:others_read_content, true)
      @admin = Factory(:admin, :group => @container).member
      @participant = Factory(:participant, :group => @container).member
    end

    it_should_authorize(:admin, :read, :article)
    it_should_authorize(:admin, :update, :article)
    it_should_authorize(:admin, :delete, :article)
    it_should_authorize(:participant, :read, :article)
    it_should_authorize(:participant, :update, :article)
    it_should_authorize(:participant, :delete, :article)
    it_should_authorize(Anonymous.current, :read, :article)
    it_should_not_authorize(Anonymous.current, :update, :article)
    it_should_not_authorize(Anonymous.current, :delete, :article)

    describe "with private article" do

      before(:all) do
        @article.update_attribute :public_read, false
      end

      it_should_authorize(:admin, :read, :article)
      it_should_authorize(:admin, :update, :article)
      it_should_authorize(:admin, :delete, :article)
      it_should_authorize(:participant, :read, :article)
      it_should_authorize(:participant, :update, :article)
      it_should_authorize(:participant, :delete, :article)
      it_should_authorize(Anonymous.current, :read, :article)
      it_should_not_authorize(Anonymous.current, :update, :article)
      it_should_not_authorize(Anonymous.current, :delete, :article)
    end

  end

  describe "in user" do

    before(:all) do
      @article = Factory(:user_article)
      @user = @article.container
    end

    it_should_authorize(:user, :read, :article)
    it_should_authorize(:user, :update, :article)
    it_should_authorize(:user, :delete, :article)
    it_should_authorize(Anonymous.current, :read, :article)
    it_should_not_authorize(Anonymous.current, :update, :article)
    it_should_not_authorize(Anonymous.current, :delete, :article)

    describe "with private article" do

      before(:all) do
        @article.update_attribute :public_read, false
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
