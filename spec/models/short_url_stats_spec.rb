require 'spec_helper'

describe ShortUrlStats do
  fixtures :short_urls
  before do
    @short_url = short_urls(:url1)
    @short_url_stat = ShortUrlStats.new(:url_id => @short_url.id, :user_agent => "Browser")
  end
  subject{@short_url_stat}
  
  it {should respond_to(:user_agent)}
  it {should respond_to(:short_url)}
  it {should respond_to(:ip_address)}

  describe "with incomplete information" do
    describe "when both useragent and ipaddress are missing" do
      before {@short_url_stat.user_agent = nil}
      it {should_not be_valid}
    end
  end

  describe "with minimal information" do
    it {should be_valid}
  end

  describe "with invalid short url reference" do
    before do
      @short_url_stat.url_id = nil
    end  
    it {should be_invalid} 
  end

  describe "with valid short url reference" do
    it {should be_valid}
  end
end
