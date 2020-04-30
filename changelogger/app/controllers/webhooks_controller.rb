class WebhooksController < ApplicationController
  WEBHOOK_HEADERS = %w(HTTP_USER_AGENT CONTENT_TYPE HTTP_X_GITHUB_EVENT HTTP_X_GITHUB_DELIVERY HTTP_X_HUB_SIGNATURE)

  def create
    puts JSON.pretty_generate(params.to_unsafe_h)
    WEBHOOK_HEADERS.each do |header|
      puts "#{header}: #{request.headers[header]}"
    end
  end
end
