module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    
    # when /^the users settings tiles\s?page$/
    #   '/tiles'

    when /^the users settings page$/
      '/users/settings'

    when /^the login page$/
      '/users/sign_in'

    when /^the dashboard$/
      '/dashboard'

    when /^the signup page$/
      '/users/sign_up'

    when /^the new project page$/
      '/projects/new'

    when /the project page of "(.+)"/
      p = Project.find_by_title($1)
      project_path(p)

    when /the edit page of the project "(.+)"/
      p = Project.find_by_title($1)
      edit_project_path(p)

    when /the profile of user "(.+)"/
      u = User.find($1)
      user_profile_path(u)

    when /^the forgot password page$/
      '/users/password/new'

    when /the donation page of the project "(.+)"/
      p = Project.find_by_title($1)
      project_donations_path(p)

    when /^the message page$/
      '/users/messages'

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
