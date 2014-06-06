class Api

  def self.tokenize text
    ret = UnicodeUtils.downcase(text)
    ret = ret.split(/[[[:punct:]][[:space:]]0-9]+/)
    ret.select! {|w| w.size > 2}
    return ret
  end

  def self.suggestions text, tags

    #ret = ApiController.tf_idf text
    ret = Api.keywords_old text
    ret.map! {|v| v[0]}
    ret = ret - tags
    ret = ret[0, 5]
    return ret

  end

  def self.keywords_old text
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

  def self.keywords text
    words = Api.tokenize text
    dictionary = {}
    tf = Hash.new(0)
    words.each do |word|
      stem = word.stem
      dictionary[stem] = word
      tf[stem] += 1
    end

    results = {}

    tf.keys.each do |stem|
      stats = Api.stem_stats stem
      next unless stats["tf"] > 0
      score = (tf[stem].to_f * Math.log(9231894.to_f/stats["wiki"].to_f))
      results[stem] = score
      #puts "#{score} #{stem} #{dictionary[stem]} #{tf[stem]} #{stats["tf"]} #{stats["df"]} #{stats["wiki"]}"
    end

    #puts "---"

    sorted = results.sort_by { |k,v|  v}

    sorted.reverse!

    ret = []

    sorted = sorted[0, 5]
    
    sorted.each do |s|
      ret.push dictionary[s[0]]
      #puts "#{dictionary[s[0]]} #{s[1]}"
    end

    #puts stats

    #puts ret
    return ret

  end

  def self.stem_stats stem
    es_client = Elasticsearch::Client.new

    result = es_client.get index: 'diplomka', type: 'stems', id: stem, ignore: 404

    ret = {
      "tf" => 0,
      "df" => 0,
      "wiki" => 0
    }

    if result
      ret = result["_source"]
    end

    return ret
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