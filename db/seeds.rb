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
  site_url: 'http://www.charity-map.org',
  blog_url: 'http://blog.charity-map.org',
  donation_means_url: 'http://blog.charity-map.org/private/71748357349/tumblr_myoc4q5MmM1s0r4ek',
  privacy_url: 'http://blog.charity-map.org/private/71748490687/tumblr_myoc91VcPg1s0r4ek',
  contact_url: 'http://blog.charity-map.org/private/71748519572/tumblr_myoc9vT8zV1s0r4ek',
  faq_url: 'http://blog.charity-map.org/private/71748700910/tumblr_myocffGbZ41s0r4ek',
  campaign_url: 'http://blog.charity-map.org/private/71748694349/tumblr_myocf71RIY1s0r4ek',
  guide_url: 'http://blog.charity-map.org/private/71748683880/tumblr_myocewes0Q1s0r4ek',
  email_contact: 'team@charity-map.org',
  central_latitude: 11.775948,
  central_longitude: 108.061523
}.each do |name, value|
  conf = Configuration.find_or_initialize_by_name name
  conf.update({
    value: value
  })
end