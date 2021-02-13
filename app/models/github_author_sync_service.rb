class GithubAuthorSyncService
  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end

  def sync_author
    case action
    when 'opened'
      handle_opened
    when 'edited'
      handle_edited
    when 'deleted'
      handle_deleted
    end
  end

  private

  def handle_opened
    create_author if author.nil?
  end

  def handle_edited
    if author.nil?
      create_author
    else
      author.update_attributes name: issue_title, bio: issue_body
    end
  end

  def handle_deleted
    author.books.each(&:destroy)
    author.destroy
  end
  FIRST_BOOK_TITLE = 'El primer libro maravilloso'.freeze
  FIRST_BOOK_PRICE = 10
  def create_author
    new_author = Author.create(github_issue_id: issue_number, name: issue_title, bio: issue_body)
    Book.create(title: FIRST_BOOK_TITLE, price: FIRST_BOOK_PRICE, author: new_author, publisher: new_author)
  end

  def issue_body
    payload['issue']['body']
  end

  def issue_title
    payload['issue']['title']
  end

  def issue_number
    payload['issue']['number']
  end

  def action
    payload['action']
  end

  def author
    Author.find_by(github_issue_id: issue_number)
  end
end