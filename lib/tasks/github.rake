namespace :github do
  desc 'populate the GitHub issues on a GitHub repo'
  task populate_issues: :environment do
    service = ServiceGithub.new
    service.github
    service.new_issues
  end
end
