$(document).ready ->
  percentage_obj_list = $(".project-progressbar .project-progressbar--green")
  percentage_obj_list.each (index) ->
    percentage_value = $(this).attr("data_percentage")
    real_percentage_value = percentage_value * 260 / 100
    $(this).css "width", real_percentage_value

  $(".show-chart").click ->
    bar_display = $(this).parents(".bar-display")
    donation_chart = $(".donation-chart", bar_display)
    donation_chart.toggle()