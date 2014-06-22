class Translator

  def initialize

    @stemmer = StemmerApi.new
    @dictionary = {}

    path = "#{File.dirname(__FILE__)}/../../data/word_dictionary.txt"

    File.readlines(path).each do |line|
      line.chomp!
      line = line.split("\t")
      @dictionary[line[0]] = line[1]
    end

  end

  def translate text
    translated = []
    text.split(" ").each do |word|
      translated.push(@dictionary[word].to_s)
    end
    result = translated.join(" ")
    result.gsub(/ +/, " ")
    result.strip!
    return result
  end

  def translate_and_stem text
    text = translate text
    text = @stemmer.get_stem text
  end

end