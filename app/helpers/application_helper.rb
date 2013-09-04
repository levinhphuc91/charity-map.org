module ApplicationHelper
  def human_time(time)
    time.strftime("%d/%m/%Y")
  end

  def human_currency(amount)
    number_to_currency amount, delimiter: ".", precision: 0, unit: "đ"
  end

  def human_status(project)
    case project.status
    when "DRAFT"
      "Bản Nháp"
    when "PENDING"
      "Đang Đợi Xét"
    when "REVIEWED"
      if project.start_date < Date.today && project.end_date > Date.today
        "Đang Gây Quỹ"
      else
        "Được Duyệt Để Gây Quỹ"
      end
    when "FINISHED"
      "Hoàn Thành"
    else
      status
    end
  end
end
