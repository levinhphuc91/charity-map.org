json.array! @projects do |project|
  json.title project.title
  json.location project.location
  json.progress project.donations_sum / project.funding_goal
  json.thumbnail (project.photo? ? project.photo_url(:thumb) : "http://www.charity-map.org/ph_project-thumbnail-bht.jpg")
end