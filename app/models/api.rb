class Api

  def initialize text, tags
    @text = text
    @tags = tags
    @keywords = Api.keywords @text
  end

  def get_result from, size
    result = {}
    result['images'] = search(from, size)

    suggested_tags = @keywords.map {|v| v[0]}
    suggested_tags = suggested_tags - @tags

    result['suggested_tags'] = suggested_tags[0, 5]
    return result
  end

  def self.tokenize text
    ret = UnicodeUtils.downcase(text)
    ret = ret.split(/[[[:punct:]][[:space:]]0-9]+/)
    ret.select! {|w| w.size > 2}
    return ret
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

    sorted = results.sort_by { |k,v|  v}

    sorted.reverse!

    return sorted

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

  def search(from, size)

    es_client = Elasticsearch::Client.new

    must = []
    @tags.each do |tag|
      term = {
        term: {
          keywords: tag
        }
      }
      must.push term
    end

    should = []
    @keywords[0, 10].each do |kw|
      term = {
        term: {
          keywords: kw[0]
        }
      }
      should.push term
    end

    ret = es_client.search index: "diplomka", body: {
      size: size,
      from: from,
      query: {
        bool: {
          must: must,
          should: should
        }
      }
    }

    #match: {keywords: @text}
    return ret
  end

end