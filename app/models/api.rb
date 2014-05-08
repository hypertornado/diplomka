class Api

  def self.tokenize text
    ret = UnicodeUtils.downcase(text)
    ret = ret.split(/[[[:punct:]][[:space:]]\t]+/)
    ret.select! {|w| w.size > 0}
    return ret
  end

  def self.suggestions text, tags

    #ret = ApiController.tf_idf text
    ret = Api.keywords text
    ret.map! {|v| v[0]}
    ret = ret - tags
    ret = ret[0, 5]
    return ret

  end

  def self.keywords text
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

  def self.search(text, tags, from, size)

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