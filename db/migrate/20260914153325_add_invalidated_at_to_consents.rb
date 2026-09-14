class AddInvalidatedAtToConsents < ActiveRecord::Migration[8.1]
  def change
    add_column :consents, :invalidated_at, :datetime
  end
end
