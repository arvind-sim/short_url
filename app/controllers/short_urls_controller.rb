class ShortUrlsController < ApplicationController
  def index
    @short_url = ShortUrl.new
    respond_to do |format|
      format.html
      format.json do
render :json => {:message => "Welcome to Short Url Service. Post a url using param 'target_url' to get short url."} and return
      end
    end
  end

  def new
    @short_url = ShortUrl.new
  end
  
  def create
    original = ''
    if params[:short_url]
      original = params[:short_url][:original]
    elsif params[:target_url]
      original = params[:target_url]
    end
    @short_url = ShortUrl.find_or_create_by_original(original)
    if !@short_url.save
      error_msg = "Url #{@short_url.errors.values.first.first}"
      respond_to do |format|
        format.html do
          flash[:error] = error_msg
          render 'new'
        end
        format.json do
          render :json => {:error => error_msg}, :status => :unprocessable_entity and return
        end
      end
    else
      respond_to do |format|
        format.html
        format.json do
          render :json => {:submitted_url => @short_url.original, :shortened_url => "#{request.host_with_port}/#{@short_url.truncated}"} and return
        end
      end
    end
  end

  def view
    if !params[:id].blank?
      if short_url = ShortUrl.find_by_truncated(params[:id])
        short_url.track_usage(request.remote_ip, request.user_agent)
        redirect_to short_url.original
      else
        flash[:error] = "Could not find the url"
        redirect_to :action => :new
      end
    end
  end
  
  def stats
    if short_url = ShortUrl.find_by_truncated(params[:id])
      respond_to do |format|
        @url_name = short_url.original
        format.html {@stats = short_url.stats}
        format.json do
          render :json => {:url => short_url.original, :stats => short_url.stats, :stats_count => short_url.stats.count}
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = 'Invalid url'
          redirect_to :action => :new
        end
        format.json do
          render :json => {:message => "Invalid url"} and return
        end
      end
    end  
  end
end
