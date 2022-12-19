class CreateArchiveDownloadRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :archive_download_requests do |t|
      t.integer :status, null: false, default: 0
      t.string :storage_url
      t.string :mdl_identifier, null: false
      t.datetime :expires_at

      t.timestamps
    end
  end
end
