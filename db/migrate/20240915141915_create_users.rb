# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest

      t.timestamps
    end

    # Add a unique index to the email column to ensure uniqueness
    add_index :users, "LOWER(email)", unique: true
  end
end
