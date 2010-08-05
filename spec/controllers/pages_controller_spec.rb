require 'spec_helper'

describe PagesController do
  render_views # force rspec to actually render views, not just test the actions
  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App |"
  end

  describe "GET 'home'" do
    describe "when not signed in" do
      it "should be successful" do
        get :home
        response.should be_success
      end

      it "should have the right title" do
        get :home
        response.should have_selector("title",
                                      :content => "#{@base_title} Home")
      end
    end # when not signed in

    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should show delete links" do
        # Create a micropost so we get a delete link
        @user.microposts.create!(:content => "Blah")
        get :home
        response.should have_selector('td > a[data-method="delete"]',
                                      :content => "delete")
      end

      it "should have the right follower/following counts" do
        get :home
        response.should have_selector('a', :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector('a', :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end # when signed in
  end # GET 'home'

  describe "GET 'contact'" do
    before(:each) do
      get 'contact'
    end
    it "should be successful" do
      response.should be_success
    end
    it "should have the right title" do
      response.should have_selector("title",
        :content => "#{@base_title} Contact")
    end
  end

  describe "GET 'about'" do
    before(:each) do
      get 'about'
    end
    it "should be successful" do
      response.should be_success
    end
    it "should have the right title" do
      response.should have_selector("title",
                                    :content => "#{@base_title} About")
    end
  end
end
