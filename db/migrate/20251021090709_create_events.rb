class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string         :title, null: false
      t.date           :date, null: false
      t.time           :time
      t.integer        :features
      t.string         :location, null: false
      t.text           :description, null: false
      t.references     :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
