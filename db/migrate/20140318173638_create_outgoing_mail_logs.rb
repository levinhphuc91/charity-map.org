class CreateOutgoingMailLogs < ActiveRecord::Migration
  def change
    create_table :outgoing_mail_logs do |t|
      t.string :email
      t.string :event
      t.string :title

      t.timestamps
    end
  end
end
