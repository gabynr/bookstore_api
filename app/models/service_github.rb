class ServiceGithub
  def initialize
    @client = Octokit::Client.new(access_token: ENV['GITHUB_SECRET'])
  end

  def new_issues
    list_author = Author.select('authors.name as name, authors.id as id').where(github_issue_id: nil)
    list_author.each do |l|
      new_issue = @client.create_issue('gabynr/bookstore4', l.name)
      author = Author.find_by(id: l.id)
      author.update(github_issue_id: new_issue.number)
    end
  end

  def github
    user = @client.user
    user.login
    puts user.inspect
  end
end