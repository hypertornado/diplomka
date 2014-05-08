require "stemmify"

class ImportLine

  def initialize line

    raise "line not valid: " unless ImportLine.valid? line

    fields = split_fields line
    @locator = fields[0]
    @title = fields[1]
    @description = fields[2]
    @keywords = fields[3]

    #puts @keywords if @locator.match("736665")
  end

  def es_import client, index
    client.index index: index, type: "image", id: @locator, body: {
      locator: @locator,
      title: @title,
      description: @description,
      keywords: @keywords,
      stems: get_stems()
    }

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

  def import_words vocabulary

    used_words = {}

    words = @keywords.split(" ")
    words += @title.split(" ")
    words.each do |word|
      word.downcase!
      #puts "#{word}\t#{word.stem}"
      stem = word.stem

      if vocabulary.has_key?(stem)
        entry = vocabulary[stem]
        entry[:tf] += 1
        entry[:df] += 1 unless used_words.has_key?(stem)
      else
        entry = {
          tf: 1,
          df: 1
        }
        vocabulary[stem] = entry
      end
      used_words[stem] = 1
    end
  end

  def split_fields line
    ret = line.scan(/"[^"]*"/)
    #remove first and last '"' chars
    ret.map do |el|
      el.chop[1..-1]
    end
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