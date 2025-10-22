class CreateNotices < ActiveRecord::Migration[7.1]
  def change
    create_table :notices do |t|
      t.string         :title, null: false
      t.text           :content, null: false
      t.boolean        :importance, default: false
      t.boolean        :pinned, default: false
      t.references     :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
