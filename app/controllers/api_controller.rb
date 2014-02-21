class ApiController < ApplicationController

  def status
    #stat = ok: true
    render json: true
  end
  
end
