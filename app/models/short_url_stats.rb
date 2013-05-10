class ShortUrlStats < ActiveRecord::Base
  attr_accessible :ip_address, :url_id, :user_agent
  belongs_to :short_url, :foreign_key => 'url_id'
  validates :user_agent, :presence => true, :if => "ip_address.blank?"
  validates :ip_address, :presence => true, :if => "user_agent.blank?"
  validate :short_url_valid

  def short_url_valid
    errors.add(:url_id, "is not valid") unless !ShortUrl.find_by_id(url_id).nil?
  end

end
