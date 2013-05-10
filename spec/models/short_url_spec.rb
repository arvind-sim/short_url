require 'spec_helper'

describe ShortUrl do
  fixtures :short_urls
  before {@short_url = ShortUrl.new(:original => 'http://www.example.com')}

  subject {@short_url}
  it {should respond_to(:original)}
  it {should respond_to(:truncated)}
  it {should respond_to(:truncated_url)}
  it {should respond_to(:stats)}

  describe "when original is missing" do
    before {@short_url.original = ''}
    it {should_not be_valid}
  end

  describe "when original is invalid" do
    before {@short_url.original = "www.example.com"}
    it {should_not be_valid}
  end

  describe "when original is valid and saved" do
    before do
      @short_url_1 = ShortUrl.new(:original => 'http://www.example.com')
      @short_url_1.save!
    end
    it "should have valid truncated url" do
      @short_url_1.truncated.should_not be_blank
    end
  end

  describe "stats for existing short url" do
    before {@stats = short_urls(:url1)}
    it "should have method to access related stats" do
      @stats.stats.length == 2
    end
  end
end
