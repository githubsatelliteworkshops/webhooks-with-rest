class WebhooksController < ApplicationController
  WEBHOOK_HEADERS = %w(HTTP_USER_AGENT CONTENT_TYPE HTTP_X_GITHUB_EVENT HTTP_X_GITHUB_DELIVERY HTTP_X_HUB_SIGNATURE)

  before_action :verify_event_type!

  def create
    puts "octokit user: #{octokit.user}"

    return unless closed?
    return unless merged?
    return unless changelog_enabled?

    puts JSON.pretty_generate(params.to_unsafe_h)
    WEBHOOK_HEADERS.each do |header|
      puts "#{header}: #{request.headers[header]}"
    end
  end

  private

  def verify_event_type!
    type = request.headers["HTTP_X_GITHUB_EVENT"]
    return if type == "pull_request"
    render(status: 422, json: "unallowed event type: #{type}")
  end

  def closed?
    params["webhook"]["action"] == "closed"
  end

  def merged?
    !!params["pull_request"]["merged"]
  end

  def changelog_enabled?
    params["pull_request"]["labels"].any? do |label|
      label["name"] == "documentation"
    end
  end

  def octokit
    @octokit ||= Octokit::Client.new(access_token: Changelogger::Application.credentials.github_personal_access_token)
  end
end
