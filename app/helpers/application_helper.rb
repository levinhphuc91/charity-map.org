module ApplicationHelper
  def human_time(time)
    time.strftime("%d/%m/%y %H:%M")
  end

  def human_currency(amount)
    number_to_currency amount, delimiter: ".", precision: 0, unit: "đ"
  end

  def human_status(status)
    case status
    when "DRAFT"
      return "Bản Nháp"
    when "PENDING"
      return "Đã Gửi Lên Hệ Thống"
    when "REVIEWED"
      return "Được Duyệt Để Gây Quỹ"
    when "FINISHED"
      return "Hoàn Thành"
    else
      return status
    end
  end
end
