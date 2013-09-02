module ApplicationHelper
  def human_time(time)
    time.strftime("%d/%m/%y %H:%M")
  end

  def human_currency(amount)
    number_to_currency amount, delimiter: ".", precision: 0, unit: "đ"
  end
end
