module DonationsHelper

  def auto_select_project_reward(project, donation_amount)
    @rewards = project.project_rewards
    @donation_amount = donation_amount.to_f
    @reward_amounts = @rewards.map(&:amount)
    case @rewards.count
    when 1
      return @rewards[0].id
    else
      if @donation_amount < @reward_amounts.first
        return nil
      elsif @donation_amount >= @reward_amounts.last
        return @rewards.last.id
      else
        (0..@reward_amounts.count - 2).each do |index|
          return @rewards[index].id if (@donation_amount >= @reward_amounts[index] && @donation_amount < @reward_amounts[index+1])
        end
      end
    end
  end

  def sort_donations(donations, sort_by)
    case sort_by
    when "updated_at"
      return donations.group_by { |donation| donation.updated_at.to_date }
    when "collection_method"
      return donations.group_by { |donation| donation.collection_method }
    when "amount"
      return donations.order("amount DESC")
    end
  end

  def reward_popularity(project)
    reward_popularity = Hash.new
    project_rewards = project.project_rewards
    project_rewards.each do |reward|
      donations = project.donations.select("COUNT(id) as total_donors, SUM(amount) as total_amount")
                                   .where("status = ? AND project_reward_id = ?","SUCCESSFUL",reward.id)
      reward_popularity[reward.amount] =  donations               
    end
    return reward_popularity
  end
  
  def funding_progress(project)
    funding_progress = Hash.new
    donations = project.donations.select("date(updated_at) as updated_at, SUM(amount) as total_amount")
                                 .where("status = ?", "SUCCESSFUL")
                                 .group("date(updated_at)")
    offset = project.start_date.midnight.to_s
    start_date = project.start_date.midnight.to_date
    end_date = project.end_date.midnight.to_date
    # while(offset <= end_date)
    #   flag = 0
    #   donations.each do |donation|
    #     if(donation.updated_at.midnight == offset)
    #       funding_progress[offset] = donation.total_amount
    #       flag = 1
    #       break
    #     end
    #   end
    #   if(flag == 0)
    #     funding_progress[offset] = 0
    #   end
    #   offset = offset.next
    # end
    prev_day_amount = 0;
    start_date.upto(end_date) do |day|
      flag = 0
      donations.each do |donation|
        if(donation.updated_at.to_s(:db) == day.to_s(:db))
          funding_progress[donation.updated_at.to_s(:db)] = donation.total_amount + prev_day_amount
          prev_day_amount = donation.total_amount + prev_day_amount
          flag = 1
          break
        end
      end
      if(flag == 0)
        funding_progress[day.to_s(:db)] = prev_day_amount
      end
    end
    return funding_progress
  end

end
