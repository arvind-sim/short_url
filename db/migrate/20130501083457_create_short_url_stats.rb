class CreateShortUrlStats < ActiveRecord::Migration
  def change
    create_table :short_url_stats do |t|
      t.integer :url_id
      t.string :user_agent
      t.string :ip_address

      t.timestamps
    end
    add_index :short_url_stats, :url_id
  end
end
