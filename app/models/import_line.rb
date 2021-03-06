class ImportLine

  def initialize line

    raise "line not valid: " unless ImportLine.valid? line

    fields = ImportLine.split_fields line
    @locator = fields[0]
    @title = fields[1]
    @description = fields[2]
    @keywords = fields[3]

    #puts @keywords if @locator.match("736665")
  end

  def es_import client, index, language_tools

    all_stems = {}

    SUPPORTED_LANGUAGES.each do |language|
      tool = language_tools[language]
      stems = @keywords
      stems = tool.lowercase_line stems
      stems = language_tools[PRIMARY_LANGUAGE].translate_line(stems, language)
      stems = tool.stem_line stems
      all_stems[language] = stems
    end

    body = {
      locator: @locator,
      title: @title,
      description: @description,
      keywords: @keywords,
    }

    all_stems.each do |k, v|
      body["stems_#{k}"] = v
    end

    #puts body

    client.index index: index, type: "image", id: @locator, body: body

  end

  def get_stems_cs translator
    text = "#{@title} #{@keywords}"
    text = translator.translate(text)
    return StemmerApi.stem_czech(text)
  end

  def get_stems
    text = "#{@title} #{@keywords}"
    words = text.split(" ")
    stems = []
    words.each do |word|
      word.downcase!
      stem = word.stem
      stems.push(stem)
    end
    stems.uniq!
    return stems.join(" ")
  end

  def self.get_phrases line
    fields = ImportLine.split_fields(line)
    keywords = fields[2]
    candidates = keywords.split(",")
    return [] if candidates.size <= 1
    ret = []
    candidates.each do |c|
      c.strip!
      if c.include? " " and c.split(" ").size <= 4
        ret.push(c)
      end
    end
    return ret
  end

  def get_plaintext
    ret = "#{@keywords} #{@title}"
    return ret.strip
  end

  def import_words_plain vocabulary

    words = @keywords.split(" ")
    words += @title.split(" ")
    words.each do |word|
      word.downcase!
      vocabulary[word] = true
    end
  end

  def self.split_fields line
    ret = line.scan(/"[^"]*"/)
    #remove first and last '"' chars
    ret.map! do |el|
      el.chop[1..-1]
    end
    return ret
  end

  def self.valid? line
    ret = false
    begin
      ret = true if line.match(/^"[0-9]+"/)
    rescue
      #this happens with bad encoding
      puts "line validation exception: #{line}"
    end

    return ret
  end

end