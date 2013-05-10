class CreateShortUrls < ActiveRecord::Migration
  def change
    create_table :short_urls do |t|
      t.string :original
      t.string :truncated

      t.timestamps
    end
  end
end
