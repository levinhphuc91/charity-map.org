class AddBankInfoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :bank_info, :text
  end
end
