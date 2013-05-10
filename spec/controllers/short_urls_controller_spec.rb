require 'spec_helper'

describe ShortUrlsController do
  fixtures :short_urls
  before {@request.env['HTTP_ACCEPT'] = 'application/json'}
  describe "root path access for accept type json" do
    it "should return friendly message" do
      get 'index' 
      response.body.should have_content "Welcome to Short Url Service. Post a url using param 'target_url' to get short url."
    end
  end

  describe "url posted to short url service" do
    let(:valid_url) {'http://www.mysite.com'} 
    describe "for valid url" do
      it "should include original and shortened url" do
        post 'create', {:target_url => valid_url}
        response.status.should == 200
        response.body.should have_content(valid_url)
      end
    end
    describe "for invalid url" do
      it "should include error message" do
        post 'create', {:target_url => 'foo'}
        response.status.should == 422
        response.body.should have_content('invalid')
      end
    end
  end

  describe "shortened url when accessed" do
    before {@short_url = short_urls(:url1)}
    it "should redirect to original url" do
      post "view", :id => @short_url.truncated
      response.status.should == 302
      response.should redirect_to(@short_url.original)
    end
  end
  describe "shortened url request for stats" do
    describe "for valid url" do
      before {@short_url = short_urls(:url1)}
      it "should receive stats" do
        post "stats", :id => @short_url.truncated
        response.status.should == 200
        response.body.should have_content(@short_url.original)
      end
    end
    describe "for invalid url" do
      it "should error message" do
        post "stats", {:id => ""}
        response.status.should == 200
        response.body.should have_content("Invalid url")
      end
    end  
  end

end
