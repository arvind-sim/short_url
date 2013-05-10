class ShortUrl < ActiveRecord::Base
  attr_accessible :original, :truncated
  VALID_URL = /\A['http:\/\/']+[a-z]+\.[a-z]+\.[a-z]+.*\z/i
  validates :original, :presence => true
  validates :original, :format => {:with => VALID_URL}, :if => '!original.blank?'
has_many :stats, :class_name => 'ShortUrlStats', :foreign_key => 'url_id', :dependent => :destroy
  before_save :truncate_url

  def truncated_url
    range = [*'0'..'9', *'A'..'Z']
    Array.new(10){range.sample}.join
  end

  def track_usage(ip_addr, usr_agnt)
    self.stats.create!(:ip_address => ip_addr, :user_agent => usr_agnt)
  end

  private
  def truncate_url
    if new_record?
      self.truncated = self.truncated_url
    end
  end
end
