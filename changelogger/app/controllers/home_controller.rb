class HomeController < ApplicationController
  def show
    welcome = {
      title: 'Webhooks & REST API Workshop',
      description: 'Its going to be an awesome ride.'
    }
    render json: welcome
  end
end
