class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def status
    #stat = ok: true
    render json: true
  end

  def images
    data = JSON.parse(request.body.read)

    result = {}
    result['images'] = search(data["text"], data["tags"], data["from"], data["size"])
    first_result = result['images']
    first = first_result['hits']['hits'].first
    result['suggested_tags'] = []
    if first
      result['suggested_tags'] = first['_source']['title'].split(" ")
    end

    result['suggested_tags'] = suggestions data["text"], data["tags"]

    render text: result.to_json
  end

  def text

  end

  private

  def suggestions text, tags

    ret = ApiController.tf_idf text
    ret.map! {|v| v[0]}
    ret = ret - tags
    ret = ret[0, 5]
    return ret

  end

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

  def self.tf_idf text
    tf = ApiController.term_frequency text

    document_count = ApiController.num_of_documents

    max_tf = 0
    tf.each do |k, v|
      max_tf  = [max_tf, v].max
    end

    result = {}
    tf.each do |k, v|
      result[k] = (0.5 + (0.5 * (v.to_f / max_tf.to_f))) * Math.log(ApiController.document_frequency(k).to_f / document_count.to_f)
    end

    sorted = result.sort_by {|k, v| -v}

    return sorted

  end

  def self.num_of_documents
    es_client = Elasticsearch::Client.new
    return es_client.count(index: "diplomka")["count"]
  end

  def self.term_frequency text
    ret = Hash.new(0)
    ar = self.tokenize text
    ar.each {|w| ret[w] += 1}
    return ret
  end  

  def self.tokenize text
    ret = UnicodeUtils.downcase(text)
    ret = ret.split(/[[[:punct:]][[:space:]]\t]+/)
    ret.select! {|w| w.size > 0}
    return ret
  end

  def search(text, tags, from, size)

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
      size: size,
      from: from,
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
