class Api

  def initialize text, tags, language
    @text = text
    @tags = tags
    @language = language
    @dictionary = {}
    @tool = LanguageTool.new(@language)
    @keywords = keywords @text
  end

  def get_result from, size
    result = {}
    result['images'] = search(from, size)

    suggested_tags = @keywords.map {|v| @dictionary[v[0]]}
    suggested_tags = suggested_tags - @tags

    result['suggested_tags'] = suggested_tags[0, 5]
    return result
  end

  def keywords text
    text = @tool.lowercase_line(text)
    words = @tool.tokenize(text)
    tf = Hash.new(0)
    words.each do |word|
      stem = @tool.stem_word(word)
      @dictionary[stem] = word
      tf[stem] += 1
    end

    results = {}

    tf.keys.each do |stem|
      stats = stem_stats(stem)
      next unless stats["wiki"] > 0
      score = (tf[stem].to_f * Math.log(9231894.to_f/stats["wiki"].to_f))
      results[stem] = score
    end

    sorted = results.sort_by { |k,v|  v}

    sorted.reverse!

    return sorted

  end

  def stem_stats stem
    es_client = Elasticsearch::Client.new

    result = es_client.get index: 'stems', type: @language, id: stem, ignore: 404

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

    stem_field = "stems_#{@language}"

    must = []
    @tags.each do |tag|
      tag = @tool.lowercase_line(tag)
      tag = @tool.stem_word(tag)
      term = {
        term: {
          stem_field => tag
        }
      }
      must.push term
    end

    should = []
    @keywords[0, 10].each do |kw|
      term = {
        term: {
          stem_field => kw[0]
        }
      }
      should.push term
    end

    body = {
      size: size,
      from: from,
      query: {
        bool: {
          must: must,
          should: should
        }
      }
    }

    ret = es_client.search index: "diplomka", body: body

    return ret
  end

end