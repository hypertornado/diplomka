require_relative "import_line.rb"

namespace :es do

  task :extract_most_frequent_trigrams do

    limit = 300

    SUPPORTED_LANGUAGES.each do |language|
      trigrams = Hash.new(0)

      Dir.entries("#{File.dirname(__FILE__)}/../../data/wiki_#{language}").each do |dirname|
        if dirname[0] != "."
          Dir.entries("#{File.dirname(__FILE__)}/../../data/wiki_#{language}/#{dirname}").each do |file|
            if file[0] != "."
              export_trigrams trigrams, "#{File.dirname(__FILE__)}/../../data/wiki_#{language}/#{dirname}/#{file}"
            end
          end
        end
      end


      sorted = trigrams.sort_by {|k, v| v}
      sorted.reverse!
      sorted = sorted[0, limit]
      sorted.map! {|k, v| k}

      content = sorted.join("\n")

      File.open("#{File.dirname(__FILE__)}/../../data/most_frequent_trigrams_#{language}.txt", "w").write(content)

    end

  end

  task :trigrams_to_javascript_classes do

    js_content = "goog.provide(\"oo.diplomka.Languages.Data\");\n\noo.diplomka.Languages.Data = function() {\n";

    js_content += "this.languages = [\"#{SUPPORTED_LANGUAGES.join("\",\"")}\"];\n\n";

    js_content += "this.languageNames = {\n";
    0.upto(SUPPORTED_LANGUAGES.size - 1).each do |i|
      js_content += ",\n" if i != 0
      js_content += "  \"#{SUPPORTED_LANGUAGES[i]}\":\"#{LANGUAGE_NAMES[i]}\""
    end
    js_content += "\n};\n\n";

    js_content += "this.trigrams = {};\n";

    SUPPORTED_LANGUAGES.each do |language|
      lines = File.readlines("#{File.dirname(__FILE__)}/../../data/most_frequent_trigrams_#{language}.txt")
      lines.map! {|v| v.chomp!}
      lines.select! {|v| v.to_s.size == 3}

      lines.map! {|v| v.to_s.gsub("\"", "\\\"")}

      content = lines.join('","')

      js_content += "this.trigrams[\"#{language}\"] = [\"#{content}\"];" + "\n"

    end

    js_content += "\n}";

    File.open("#{File.dirname(__FILE__)}/../../public/js/js/diplomka/languages/data.js", "w").write(js_content)


  end


  task :export_profimedia_words_for_translation do
    path = "#{File.dirname(__FILE__)}/../../data/profi-text-cleaned.csv"

    src_encoding = "Windows-1252"
    target_encoding = "utf-8"

    vocabulary = {}

    i = 0
    File.open(path).each do |line|
      print "\r#{i}"
      line = line.encode(target_encoding, src_encoding)

      if ImportLine.valid? line
        ImportLine.new(line).import_words_plain(vocabulary)
      end

      i += 1
    end
    print "\r"

    file = File.open("#{File.dirname(__FILE__)}/../../data/word_list.txt", "w")

    i = 0
    vocabulary.each do |k, v|
      line = "#{k}\n"
      print "\rwriting #{i}"
      file.write(line)
      i += 1
    end

    print "\r"
  end

  task :import_profimedia_words do
    path = "#{File.dirname(__FILE__)}/../../data/profi-text-cleaned.csv"
    #path = "#{File.dirname(__FILE__)}/../../data/tiny"

    src_encoding = "Windows-1252"
    target_encoding = "utf-8"

    vocabulary = {}

    i = 0
    File.open(path).each do |line|
      print "\r#{i}"
      line = line.encode(target_encoding, src_encoding)

      if ImportLine.valid? line
        ImportLine.new(line).import_words(vocabulary)
      end

      i += 1
    end
    print "\r"

    file = File.open("#{File.dirname(__FILE__)}/../../data/tf_df_list.txt", "w")

    i = 0
    vocabulary.each do |k, v|
      line = "#{k}\t#{v[:tf]}\t#{v[:df]}\n"
      print "\rwriting #{i}"
      file.write(line)
      i += 1
    end

    print "\r"

  end

  task :import => :environment do
    #around 20 M images
    path = "#{File.dirname(__FILE__)}/../../data/profi-text-cleaned.csv"
    #path = "#{File.dirname(__FILE__)}/../../data/tiny"

    translator = Translator.new

    puts "Importing data to elasticsearch - #{Time.now}"
    src_encoding = "Windows-1252"
    target_encoding = "utf-8"

    es_client = Elasticsearch::Client.new
    #clear_type(es_client, ES_INDEX, "image")

    i = 0
    timestamp = Time.now
    eta = ""
    File.open(path).each do |line|
      if (i % 1000 == 0)
        new_timestamp = Time.now
        diff = (new_timestamp - timestamp) * 1000.0
        remaining = 20000000.to_f - i
        eta = (remaining / 1000.0) * diff
        eta = (eta / 1000).to_i
        eta = Time.at(eta).gmtime.strftime('%R:%S')
        timestamp = new_timestamp
      end
      print "\r#{i} #{eta}"
      line = line.encode(target_encoding, src_encoding)
      i += 1
      if ImportLine.valid? line
        ImportLine.new(line).es_import(es_client, ES_INDEX, translator)
      end
    end
    es_client.indices.refresh
    print "\r"
    puts "Import ended - #{Time.now}"
  end

  task :pair_profimedia_and_wiki_data do
    wiki_data_path = "#{File.dirname(__FILE__)}/../../data/wiki_freq_list.txt"
    profimedia_data_path = "#{File.dirname(__FILE__)}/../../data/tf_df.txt"

    words = Hash.new(0)

    File.open(wiki_data_path).each do |line|
      c = line.split("\t")
      if c.size == 2
        words[c[0]] = c[1].to_i
      end
    end

    #output format
    #stem tf_profimedia df_profimedia tf_wiki
    file = File.open("#{File.dirname(__FILE__)}/../../data/paired_wiki_and_profimedia.txt", "w")

    File.open(profimedia_data_path).each do |line|
      line = line.chomp
      c = line.split("\t")

      #puts words[c[0]]
      line += "\t#{words[c[0]]}\n"

      file.write(line)
    end

  end

  task :import_paired do
    paired_file = "#{File.dirname(__FILE__)}/../../data/paired_wiki_and_profimedia.txt"

    es_client = Elasticsearch::Client.new

    index_name = "stems"

    i = 0

    File.open(paired_file).each do |line|
      line.chomp!
      entries = line.split("\t")
      #puts entries
      print "\r#{i}"
      es_client.index index: ES_INDEX, type: index_name, id: entries[0], body: {
        tf: entries[1].to_i,
        df: entries[2].to_i,
        wiki: entries[3].to_i
      }
      i += 1
    end
    puts "\r"

    es_client.indices.refresh

  end

  task :count_sum_of_wikipedia_words do
    wiki_data_path = "#{File.dirname(__FILE__)}/../../data/paired_wiki_and_profimedia.txt"

    system("cat #{wiki_data_path} | cut -f 4 | awk '{s+=$1} END {print s}'")

  end

  task :clear do
    es_client = Elasticsearch::Client.new
    es_client.indices.delete index: ES_INDEX if es_client.indices.exists index: ES_INDEX
    es_client.indices.create index: ES_INDEX
  end

  task :export_profimedia_phrases_for_translation => :environment do
    #system("cat #{File.dirname(__FILE__)}/../../data/paired_wiki_and_profimedia.txt | cut -f 1 > #{File.dirname(__FILE__)}/../../data/word_list.txt")
    path = "#{File.dirname(__FILE__)}/../../data/keyword-clean-phrase-export.csv"
    #path = "#{File.dirname(__FILE__)}/../../data/tiny"

    src_encoding = "Windows-1252"
    target_encoding = "utf-8"

    vocabulary = {}

    i = 0
    File.open(path).each do |line|
      print "\r#{i}"
      #line = line.encode(target_encoding, src_encoding)
      line = UnicodeUtils.downcase(line, :cs)

      if ImportLine.valid? line
        phrases = ImportLine.get_phrases(line)
        #puts phrases if phrases.length > 1
        phrases.each {|p| vocabulary[p] = true}
      end

      i += 1
    end
    print "\r"

    file = File.open("#{File.dirname(__FILE__)}/../../data/phrases_list.txt", "w")

    i = 0
    vocabulary.each do |k, v|
      line = "#{k}\n"
      print "\rwriting #{i}"
      file.write(line)
      i += 1
    end

    print "\r"
  end

  task :create_en_cs_vocabulary => :environment do

    #33265 words untranslated
    #google poznal named entities
    #musel jsem pouzit memsource
    #preklad na webu googlu prelozil jen 10 procent slov
    #google translator tools ma omezeni na 1 MB
    #musel jsem zrušit kapitalizeci, google napriklad vracel psČ;odstÁvČata, chovnÍ bĚhouni
    #odstranění interpunkce
    #obcas byla pomichana diakritika z jineho kodovani "boles?aw boles? aw", polske 'l'

    path_en = "#{File.dirname(__FILE__)}/../../data/word_list.txt"
    path_cs = "#{File.dirname(__FILE__)}/../../data/word_list_translated.txt"

    dictionary_path = "#{File.dirname(__FILE__)}/../../data/word_dictionary.txt"
    write_file = File.open(dictionary_path, "w")

    lines_en = File.readlines(path_en)
    lines_cs = File.readlines(path_cs)

    puts lines_en.size
    puts lines_cs.size

    0.upto(lines_cs.size - 1) do |i|
      en_word = lines_en[i].chomp
      cs_word = lines_cs[i].chomp

      cs_word = en_word if cs_word.size == 0

      cs_word = UnicodeUtils.downcase(cs_word, :cs)

      cs_word.gsub!(/[[:punct:]]/, "")
      cs_word.strip!

      line = "#{en_word}\t#{cs_word}\n"

      write_file.write(line)
    end
  end

  task :stemify_czech_words do
    puts "Stemify"
    command = "cat #{File.dirname(__FILE__)}/../../data/word_list_translated.txt | LC_ALL=UTF-8 CLASSPATH=#{File.dirname(__FILE__)}/../../lib/czech_stemmer java CzechStemmer light > #{File.dirname(__FILE__)}/../../data/word_list_translated_stemmed.txt"
    system(command)
  end

  task :test => :environment do

    correct = 0

    1.upto(10) do |n|
      name = (1000 + n).to_s[1,3]
      #"#{File.dirname(__FILE__)}/../../train_data/"
      text = File.read("#{File.dirname(__FILE__)}/../../train_data/#{name}.txt")
      test_keywords = File.read("#{File.dirname(__FILE__)}/../../train_data/#{name}.keywords").split("\n")
      puts "#{name}---"
      keywords = Api.keywords text

      keywords.map! {|w| w.stem}
      test_keywords.map! {|w| w.stem}

      puts test_keywords.join(" ")
      puts keywords.join(" ")

      puts (keywords & test_keywords).join(" ")
      
      correct += 5 - (test_keywords - keywords).size
    end

    puts "CORRECT: #{correct}"
  end

  task :start do
    puts "Starting elasticsearch"
    system("#{File.dirname(__FILE__)}/../../bin/elasticsearch/bin/elasticsearch -f")
  end

end

def clear_type client, index, type
  client.indices.delete index: index, type: type if client.indices.exists index: index
  #client.indices.create index: index
  client.indices.refresh
end

def export_trigrams trigrams, filepath
  puts filepath
  File.open(filepath, 'r:utf-8').each do |line|
    if (!line.start_with?("<doc") and !line.start_with?("</doc"))
      line = UnicodeUtils.downcase(line, :cs)
      line.chomp!
      line = " #{line} "
      0.upto(line.size - 3) do |i|
        trigram = "#{line[i]}#{line[i+1]}#{line[i+2]}"
        trigrams[trigram] += 1 if trigram.size == 3
      end
    end
  end
end

def export_wiki_words words, filepath
  puts filepath
  File.open(filepath, 'r:utf-8').each do |line|
    if (!line.start_with?("<doc") and !line.start_with?("</doc"))
      tokenize(line).each do |word|
        if word.length > 2
          word.downcase!
          #puts "#{word} #{word.stem}"
          words[word.stem] += 1
        end
      end
    end
  end
end

def tokenize line
  ret = line.split(/[\ \<\n\t[[:punct:]]0-9]/)
  return ret
end

