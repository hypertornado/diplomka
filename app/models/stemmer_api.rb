class StemmerApi

  def initialize
    @dictionary = Hash.new("")

    lines_cs = File.readlines("#{File.dirname(__FILE__)}/../../data/word_list_translated.txt")
    lines_cs_stemmed = File.readlines("#{File.dirname(__FILE__)}/../../data/word_list_translated_stemmed.txt")

    0.upto(lines_cs.size - 1) do |i|
      word = lines_cs[i].chomp
      stem = lines_cs_stemmed[i].chomp

      @dictionary[word] = stem
    end

  end

  def get_stem words
    ret = []
    words.split(" ").each do |word|
      ret.push @dictionary[word]
    end

    return ret.join " "
  end

  def self.stem_czech words
    command = "echo '#{words}' | LC_ALL=UTF-8 CLASSPATH=#{File.dirname(__FILE__)}/../../lib/czech_stemmer java CzechStemmer light 2>/dev/null"
    f = open("|#{command}")
    stemmed = f.read()
    stemmed.chomp!
    return stemmed
  end

end