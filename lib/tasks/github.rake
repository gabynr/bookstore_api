namespace :github do

  desc "populate the GitHub issues on a GitHub repo"
  task populate_issues: :environment do
    Service = ServiceGithub.new
    Service.github
    Service.new_issues
  end

end
