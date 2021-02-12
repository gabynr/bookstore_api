  class GithubsController < ApplicationController
    require 'digest'
    require 'json'
    before_action :validate_github


      def create
        if github_params["action"] == "opened" or  (github_params["action"] == "edited" and  Author.find_by(github_issue_id: github_params["issue"]["number"]).nil?)
          if Author.find_by(github_issue_id: github_params["issue"]["number"]).nil?
            author = Author.create(github_issue_id: github_params["issue"]["number"], name: github_params["issue"]["title"], bio: github_params["issue"]["body"])
            Book.create(  title:"El primer libro maravilloso", price: 10, author: author, publisher: author)
          end
        elsif github_params["action"] == "edited"
          author = Author.find_by github_issue_id: github_params["issue"]["number"]
          author.update_attributes name: github_params["issue"]["title"], bio: github_params["issue"]["body"]
        elsif github_params["action"] == "deleted"
          author = Author.find_by github_issue_id: github_params["issue"]["number"]
          author.books.each(&:destroy)
          author.destroy
        end
        head :ok
      end

    private

     def validate_github
       request.body.rewind
       payload_body = request.body.read
       verify_signature(payload_body)
       push = JSON.parse(params[:payload])
       "I got some JSON: #{push.inspect}"
     end

     def verify_signature(payload_body)
       signature = 'sha256=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['GITHUB_SECRET'], payload_body)
       head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE_256'])
     end

     def github_params
       # params.require(:payload).permit("action", issue: ["number", "title", "description"])[:payload]
       JSON.parse(params[:payload])
     end

  end