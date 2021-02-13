class GithubsController < ApplicationController
  before_action :validate_github

  def create
    GithubAuthorSyncService.new(github_params).sync_author
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
    signature = "sha256=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['GITHUB_SECRET'], payload_body)}"
    return if ActiveSupport::SecurityUtils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE_256'])

    head :unauthorized
  end

  def github_params
    JSON.parse(params[:payload])
  end

  end