$(document).ready ->
  percentage_obj_list = $(".project-progressbar .project-progressbar--green")
  percentage_obj_list.each (index) ->
    percentage_value = $(this).attr("data_percentage")
    real_percentage_value = percentage_value * 260 / 100
    $(this).css "width", real_percentage_value