class CreateInvitation < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.string :name
      t.string :email
      t.text :message
      t.string :token
      t.timestamps
    end
  end
end
