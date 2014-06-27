class LanguageTool

  @@supported_languages = SUPPORTED_LANGUAGES

  def initialize language
    raise Exception.new "Language '#{language}' not supported" unless ["en","cs"].include? language
    @language = language
    @dictionaries_path = {
      ["en","cs"] => "#{File.dirname(__FILE__)}/../../data/word_dictionary_en_cs.txt"
    }
    @loaded_dictionaries = {}

  end

  def load_dictionary target_language
    key = [@language, target_language]
    return if @loaded_dictionaries.has_key? key
    unless @dictionaries_path.has_key? key
      raise Exception.new "No dictionary for #{@language}->#{target_language} translation"
    end

    dictionary = {}
    File.readlines(@dictionaries_path[key]).each do |line|
      line.chomp!
      line = line.split("\t")
      dictionary[line[0]] = line[1]
    end

    @loaded_dictionaries[key] = dictionary
  end

  def tokenize line
    return line.split(/[\ \<\n\t[[:punct:]]0-9]+/)
  end

  def stem_word word
    case @language
    when 'en'
      return word.stem
    when 'cs'
      return CzechStemmer.stem(word)
    end
  end

  def stem_line line
    ret = []
    tokenize(line).each do |word|
      ret.push(stem_word(word))
    end
    return ret.join " "
  end

  def lowercase_line line
    return UnicodeUtils.downcase(line, :cs)
  end

  def translate_line line, target_language
    return line if target_language == @language
    load_dictionary target_language

    dictionary = @loaded_dictionaries[[@language, target_language]]
    line = lowercase_line line
    translated = []
    tokenize(line).each do |word|
      if dictionary.has_key? word
        translated.push dictionary[word]
      else
        translated.push word
      end
    end
    return translated.join " "
  end

end