class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.references :indexing_run
      t.string :job_id, null: false, index: true
      t.datetime :completed_at, index: true

      t.timestamps
    end
  end
end
