class CreateConsents < ActiveRecord::Migration[8.1]
  def change
    create_table :consents do |t|
      t.string :token_id

      t.timestamps
    end
  end
end
