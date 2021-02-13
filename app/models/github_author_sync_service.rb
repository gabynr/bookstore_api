class GithubAuthorSyncService
  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end

  def sync_author
    if payload['action'] == 'opened' || (
    payload['action'] == 'edited' &&
        Author.find_by(github_issue_id: payload['issue']['number']).nil?
    )
      if Author.find_by(github_issue_id: payload['issue']['number']).nil?
        author = Author.create(
          github_issue_id: payload['issue']['number'],
          name: payload['issue']['title'],
          bio: payload['issue']['body']
        )
        Book.create(title: 'El primer libro maravilloso', price: 10, author: author, publisher: author)
      end
    elsif payload['action'] == 'edited'
      author = Author.find_by github_issue_id: payload['issue']['number']
      author.update_attributes name: payload['issue']['title'], bio: payload['issue']['body']
    elsif payload['action'] == 'deleted'
      author = Author.find_by github_issue_id: payload['issue']['number']
      author.books.each(&:destroy)
      author.destroy
    end
  end
end