class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def status
    #stat = ok: true
    render json: true
  end

  def images
    data = JSON.parse(request.body.read)

    api = Api.new data["text"], data["tags"]

    render text: api.get_result(data["from"], data["size"]).to_json
  end

  def text

  end

  private

  def self.document_frequency term
    es_client = Elasticsearch::Client.new

    ret = es_client.search index: "diplomka", body: {
      size: 1,
      from: 0,
      query: {
        bool: {
          must: {
            term: {
              keywords: term
              }
          }
        }
      }
    }

    return ret["hits"]["total"]
  end

  def self.num_of_documents
    es_client = Elasticsearch::Client.new
    return es_client.count(index: "diplomka")["count"]
  end

  def self.term_frequency text
    ret = Hash.new(0)
    ar = Api.tokenize text
    ar.each {|w| ret[w] += 1}
    return ret
  end
  
end
