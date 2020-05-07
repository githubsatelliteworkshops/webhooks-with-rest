class WebhooksController < ApplicationController
  WEBHOOK_HEADERS = ["HTTP_USER_AGENT", "CONTENT_TYPE", "HTTP_X_GITHUB_EVENT", "HTTP_X_GITHUB_DELIVERY", "HTTP_X_HUB_SIGNATURE"]

#  before_action :verify_signature!
  before_action :verify_event_type!

  def create
    return error("not labeled") unless labeled?
    return error("not closed") unless closed?
    return error("not merged") unless merged_into_master?

#    create_changelog_entry

    puts "Webhook successfully received!!!"
    WEBHOOK_HEADERS.each do |header|
      puts "#{header}: #{request.headers[header]}"
    end
  end

  private

  def payload
    params["webhook"]
  end

  def error(msg)
    text = "Webhook invalid: #{msg}"
    puts text
    render(status: 422, json: text)
  end

  def verify_event_type!
    type = request.headers["HTTP_X_GITHUB_EVENT"]
    return if type == "pull_request"
    error("unallowed event type: #{type}")
  end

  def labeled?
    payload["pull_request"]["labels"].any? do |label|
      label["name"] == "documentation"
    end
  end

  def closed?
    payload["action"] == "closed"
  end

  def merged_into_master?
    merged = payload["pull_request"]["merged"] == true
    in_to_master = payload["pull_request"]["base"]["ref"] == "master"

    merged && in_to_master
  end

  def octokit
    Octokit::Client.new(access_token: ENV["GITHUB_PERSONAL_ACCESS_TOKEN"])
  end

#  def create_changelog_entry
#    content, sha = get_file
#    return unless content

#    octokit.update_contents(repo, # repository we're updating
#                            "docs/index.md", # file we're updating
#                            "New changelog entry", # commit message for update
#                            sha, # head sha for the file we're updating
#                            content + format_changes) # actual contents
#  end

#  def get_file
#    response = octokit.contents(repo, path: "docs/index.md")
#    [Base64.decode64(response["content"]), response["sha"]]
#  rescue
#    nil
#  end

#  def repo
#    payload["repository"]["full_name"]
#  end

#  def format_changes
#    author_avatar = payload["pull_request"]["user"]["avatar_url"]
#    author_name   = payload["pull_request"]["user"]["login"]
#    author_url    = payload["pull_request"]["user"]["html_url"]

#    diff_url = payload["pull_request"]["diff_url"]
#    pr_url = payload["pull_request"]["html_url"]

#    <<-ENTRY
## #{Time.now.utc.to_s}

#By: ![avatar](#{author_avatar}&s=50) [#{author_name}](#{author_url})

##{change_description}

#[[diff](#{diff_url})][[pull request](#{pr_url})]
#* * *
#    ENTRY
#  end

#  def change_description
#    body = payload["pull_request"]["body"]
#    if matches = body.match(/<changes>(.*)<\/changes>/m)
#      matches.captures.first.strip
#    else
#      payload["pull_request"]["title"]
#    end
#  end

#  def verify_signature!
#    secret = ENV["GITHUB_WEBHOOK_SECRET"]

#    signature = 'sha1='
#    signature += OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, request.body.read)

#    unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
#      guid = request.headers["HTTP_X_GITHUB_DELIVERY"]
#      error("unable to verify payload for #{guid}")
#    end
#  end
end
