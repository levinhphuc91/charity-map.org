namespace :orgs do

  desc "daily digest"
  task :daily_digest => :environment do
    @users = User.where('created_at >= ?', 1.day.ago)
    @projects = Project.where('created_at >= ?', 1.day.ago)
    @donations = Donation.where('created_at >= ?', 1.day.ago)
    AdminMailer.daily_digest(@users, @projects, @donations).deliver if (@users || @donations || @projects)
  end

  desc "import organizations"
  task :import => :environment do
    @file = File.new("#{Rails.root}/public/org_list.xls")
    require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open "#{Rails.root}/public/org_list.xls" #@file
    sheet1 = book.worksheet 0
    sheet1.each do |row|
      if (@org = OrganizationList.create email: row[12])
        OrganizationList.transaction do
          @org.update_attributes(name: row[0],
            website: row[1], facebook: row[2], address: row[3],
            legal_entity: row[4], geographical_area: row[5],
            category: {:first => row[6], :second => row[7], :third => row[8]},
            year_of_establishment: row[9], key_contact: row[10],
            bank_account: row[11])
        end
      else
        puts "== INVALID: #{row[12]}"
      end
    end
  end
end