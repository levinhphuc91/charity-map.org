# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Updating Configurations'

{
  site_name: 'Charity Map',
  blog_url: 'http://blog.charity-map.org',
  email_contact: 'team@charity-map.org',
}.each do |name, value|
  conf = Configuration.find_or_initialize_by_name name
  conf.update_attributes({
    value: value
  })
end