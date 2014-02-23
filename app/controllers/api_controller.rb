class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def status
    #stat = ok: true
    render json: true
  end

  def images
    data = JSON.parse(request.body.read)
    puts data

    images = ["i1", "i2"]
    es_client = Elasticsearch::Client.new

    result = {}

    result['images'] = es_client.search index: "diplomka", body: {
      query: { match: { keywords: data["text"] } }
    }
    render text: result.to_json
  end

  def text

  end
  
end
