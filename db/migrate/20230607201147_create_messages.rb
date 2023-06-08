class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :gateway, null: false, limit: 1
      t.json :payload, null: true
      t.integer :status, null: false, limit: 1
      t.json :result, null: true

      t.timestamps
    end
  end
end
