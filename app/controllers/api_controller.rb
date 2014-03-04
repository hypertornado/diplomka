class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def status
    #stat = ok: true
    render json: true
  end

  def images
    data = JSON.parse(request.body.read)

    result = {}
    result['images'] = search(data["text"], data["tags"])
    result['suggested_tags'] = ["hello", "world"]

    render text: result.to_json
  end

  def text

  end

  private

  def search(text, tags)
    es_client = Elasticsearch::Client.new

    should = []

    tags.each do |tag|
      term = {
        term: {
          keywords: tag
        }
      }
      should.push term
    end

    ret = es_client.search index: "diplomka", body: {
      query: {
        bool: {
          must: should,
          should: {
            match: {keywords: text}
          }
        }
      }
    }

    # match: { keywords: text },
    return ret
  end
  
end
