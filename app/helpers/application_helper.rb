module ApplicationHelper
  def human_time(time)
    time.strftime("%d/%m/%Y")
  end

  def human_currency(amount)
    number_to_currency amount, delimiter: ".", precision: 0, unit: "đ"
  end

  def human_project_status(project)
    case project.status
    when "DRAFT"
      "Bản Nháp"
    when "PENDING"
      "Đang Đợi Xét"
    when "REVIEWED"
      if project.start_date < Date.today && project.end_date > Date.today
        "Đang Gây Quỹ, Còn #{TimeDifference.between(project.end_date, Time.now).in_days.to_i} Ngày"
      else
        "Được Duyệt Để Gây Quỹ"
      end
    when "FINISHED"
      "Hoàn Thành"
    else
      status
    end
  end

  def human_donation_type(method)
    case method
    when "COD"
      "Thu Tiền Mặt"
    when "BANK_TRANSFER"
      "Chuyển Khoản Ngân Hàng"
    end
  end

  def human_donation_status(donation)
    case donation.status
    when "PENDING"
      if donation.collection_method == "COD"
        "Đợi Liên Hệ"
      elsif donation.collection_method == "BANK_TRANSFER"
        "Chờ MTQ Gửi Tiền"
      end
    when "REQUEST_VERIFICATION"
      "Đợi Xác Nhận"
    when "SUCCESSFUL"
      "Thành Công"
    end
  end

  def markdown(text)
    md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
    md.render(text).html_safe
  end
end
