class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def images
    data = JSON.parse(request.body.read)

    api = Api.new data["text"], data["tags"], data["language"]

    render text: api.get_result(data["from"], data["size"]).to_json
  end

  def detail

    es_client = Elasticsearch::Client.new

    result = es_client.get index: IMAGES_ES_INDEX, type: 'image', id: params['id'], ignore: [404]

    unless result
      render :status => 404, text: "404"
      return
    end

    result["suggestions"] = ["0000000003", "0000000004", "0000000005", "0000000004", "0000000005", "0000000004", "0000000005", "0000000004", "0000000005", "0000000004", "0000000005", "0000000004", "0000000005", "0000000004", "0000000005", "0000000004", "0000000005", "0000000004", "0000000005", "0000000004", "0000000005"]

    render text: result.to_json

  end
  
end
