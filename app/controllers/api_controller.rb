class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def images
    data = JSON.parse(request.body.read)

    api = Api.new data["text"], data["tags"], data["language"]

    render text: api.get_result(data["from"], data["size"]).to_json
  end
  
end
