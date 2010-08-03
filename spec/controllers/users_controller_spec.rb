require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    before(:each) do
      get 'new'
    end
    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector('title', :content => "Sign up")
    end

    it "should have a name field" do
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    it "should have an email field" do
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    it "should have a password field" do
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    it "should have a password field" do
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
  end # GET new

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
      get :show, :id => @user
    end

    it "should be successful" do
      response.should be_success
    end

    it "should find the right user" do
      assigns(:user).should == @user
    end

    it "should have the right title" do
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "",
                  :email => "",
                  :password => "",
                  :password_confirmation => ""}
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

      it "should clear the password field" do
        # Set a non-empty password so we can check that it was cleared
        hash = @attr.merge({:password => 'foobar',
                           :password_confirmation => 'foobar'})
        post :create, :user => hash
        # :value => "" ensures that the field is empty (like /^$/).
        # :content => "" does not; it will match anything (like //).
        response.should have_selector("input[name='user[password]']",
                                      :value => "")
      end
    end # failure

    describe "success" do
      before(:each) do
        @attr = {
          :name => "New User",
          :email => "user@example.com",
          :password => "foo bar baz",
          :password_confirmation => "foo bar baz"
        }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /Welcome to the sample app/i
      end
    end # success
  end # POST 'create'
end
