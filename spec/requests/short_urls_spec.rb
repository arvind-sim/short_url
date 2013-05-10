require 'spec_helper'

describe "Short Urls" do
  fixtures :short_urls

  let(:stored_url) {short_urls(:url1)}
  describe "GET /" do
    it "should return the base page" do
      visit '/'
      page.should have_selector('h1', :text => 'Short Url Service')
    end
  end

  describe "create short link" do
    before {visit '/'}
    describe "for invalid information" do
      before do
        click_button 'Generate'
      end
      it "should return error messages" do
        page.should have_content("can't be blank")
      end
    end
    describe "for valid information" do
      describe "for url not submitted already" do
        let(:url) {'http://www.temporary.com'} 
        before do
          fill_in 'Url', :with => url
          click_button 'Generate'
        end
        it "should create shortened link" do
          page.should have_content(url)
        end
      end
      
      describe "for url already in the db" do
        let(:url) {stored_url.original}
        before do
          fill_in 'Url', :with => url
          click_button 'Generate'
        end
        it "should not create new copy" do
          ShortUrl.first.truncated.should == short_urls(:url1).truncated
          ShortUrl.count.should == 1
        end
      end
    end
  end

  describe 'view' do
    before do
      @original_count = stored_url.stats.size
      visit "/#{stored_url.truncated}"
    end
    it "should increase stats by 1" do
      ShortUrlStats.count.should == (@original_count + 1)
    end
  end

  describe 'statistics' do
    describe 'for invalid url' do
      before {visit "/stats/"}
      it {page.should have_content "Invalid url"}
    end
    describe "for valid url" do
      before do
        visit "/#{stored_url.truncated}"
        visit "/stats/#{stored_url.truncated}"
      end
      it { page.should have_content(stored_url.original)}
    end
  end
end
