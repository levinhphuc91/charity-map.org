module ApplicationHelper
  def human_time(time)
    time.strftime("%d/%m/%Y")
  end

  def human_currency(amount)
    number_to_currency amount, delimiter: ".", precision: 0, unit: "VNĐ"
  end

  def human_project_status(project)
    case project.status
    when "DRAFT"
      "<i class='icon-file-text'></i> Bản Nháp"
    when "PENDING"
      "<i class='icon-spinner'></i> Đang Đợi Xét"
    when "REVIEWED"
      if project.start_date < Date.today && project.end_date > Date.today
        "<i class='icon-credit-card'></i> Đang Gây Quỹ, Còn #{TimeDifference.between(project.end_date, Time.now).in_days.to_i} Ngày"
      else
        "<i class='icon-ok-sign'></i> Được Duyệt Để Gây Quỹ</i>"
      end
    when "FINISHED"
      "<i class='icon-lock'></i> Hoàn Thành"
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
        "Chờ CK"
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

  def limit_display(text, limit)
    if text.length > limit
      "#{text[0..limit]}..."
    else
      text
    end
  end

  def donation_data_in_7_days(project)
    seven_days = Time.now.midnight - 7.days
    donations  = project.donations.select("project_id, date(created_at) as created_at, SUM(amount) as total_amount").where("status = ? AND (created_at >= ? AND created_at <= ?)",
      "SUCCESSFUL", seven_days.beginning_of_day, Time.now.midnight.end_of_day).group("date(created_at), project_id")
    return donations
  end

  def full_name_by_id(id)
    user = User.find(id)
    return user.full_name
  end
end
