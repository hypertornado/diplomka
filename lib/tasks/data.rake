namespace :data do

  task :csv => :environment do

    path = "/Volumes/ondra_zaloha/profi-neuralnet-20M.data.gz"

    limit = 100

    i = 0
    Zlib::GzipReader.open(path) do |gz|

      until (gz.eof? or i >= limit) do
        i += 1
        header = gz.readline
        vec = gz.readline

        #puts header

        header.chomp!
        line = "\"#{header.split(" ")[2]}\",\""

        vec.chomp!
        vec = vec.split(" ").join("\",\"")
        line = "#{line}#{vec}\""
        puts line
      end

    end

  end

  task :similar_images => :environment do

    path = "/Volumes/ondra_zaloha/profi-neuralnet-20M.data.gz"

    #path = "/Users/ondrejodchazel/projects/diplomka/data/tiny.gz"


    block_limit = 10000
    max_limit = 10

    sim = Similarity.new(max_limit)

    Zlib::GzipReader.open(path) do |gz|

      i = 0
      until (gz.eof? or i > block_limit) do
        print "\ri#{i}   "
        i += 1

        header = gz.readline
        vec = gz.readline

        sim.add_loaded header, vec
      end

      Zlib::GzipReader.open(path) do |gz_compare|
        j = 0
        until (gz_compare.eof? or j > block_limit) do
          print "\rj #{j}   "
          j += 1

          header = gz_compare.readline
          vec = gz_compare.readline

          sim.add_compare header, vec

        end

      end

    end

    puts ""
    puts ""

    sim.print_it

  end

  task :export_profimedia_phrases_for_translation => :environment do
    path = "#{File.dirname(__FILE__)}/../../data/keyword-clean-phrase-export.csv"

    src_encoding = "Windows-1252"
    target_encoding = "utf-8"

    vocabulary = {}

    i = 0
    File.open(path).each do |line|
      print "\r#{i}"
      line = UnicodeUtils.downcase(line, :cs)

      if ImportLine.valid? line
        phrases = ImportLine.get_phrases(line)
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

  task :translate_phrases => :environment do
    translation_path = "#{File.dirname(__FILE__)}/../../data/phrase_table_en_cs.txt"

    phrases_path = "#{File.dirname(__FILE__)}/../../data/phrases_list.txt"

    dictionary = Hash.new(nil)

    File.open(phrases_path).each do |line|
      line.chomp!
      dictionary[line] = ["", 0.to_f]
    end



    i = 0
    File.open(translation_path).each do |line|
      print "\r#{i}"
      i += 1

      parts = line.split(" ||| ")
      if dictionary.has_key?(parts[0])

        val = dictionary[parts[0]]
        score = parts[2].split(" ")[0].to_f

        if val[1] <= score
          val[0] = parts[1]
          val[1] = score
          dictionary[parts[0]] = val
        end
      end
    end

    file_out = File.open("#{File.dirname(__FILE__)}/../../data/phrases_list_translated_cs.txt", "w")

    dictionary.each do |k, v|
      if (v[1] > 0)
        line = "#{k}\t#{v[0]}\n"
        file_out.write(line)
      end
    end

  end

  task :export_profimedia_words_for_translation => :environment do
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

  task :create_tf_df_list => :environment do

    source_tool = LanguageTool.new(PRIMARY_LANGUAGE)

    SUPPORTED_LANGUAGES.each do |language|
      path = "#{File.dirname(__FILE__)}/../../data/profi-text-cleaned.csv"

      target_tool = LanguageTool.new(language)

      src_encoding = "Windows-1252"
      target_encoding = "utf-8"

      vocabulary = {}

      i = 0
      File.open(path).each do |line|
        print "\r#{language}: #{i}"
        line = line.encode(target_encoding, src_encoding)

        if ImportLine.valid? line
          used_words_in_line = {}
          parsed = ImportLine.new(line)
          plaintext = parsed.get_plaintext
          plaintext = source_tool.lowercase_line plaintext
          plaintext = source_tool.translate_line(plaintext, language)
          source_tool.tokenize(plaintext).each do |word|
            stem = target_tool.stem_word word
            if vocabulary.has_key?(stem)
              entry = vocabulary[stem]
              entry[:tf] += 1
              entry[:df] += 1 unless used_words_in_line.has_key?(stem)
            else
              entry = {
                tf: 1,
                df: 1
              }
              vocabulary[stem] = entry
            end
            used_words_in_line[stem] = 1
          end
          #ImportLine.new(line).import_words(vocabulary)
        end

        i += 1
      end
      print "\r"

      file = File.open("#{File.dirname(__FILE__)}/../../data/tf_df_list_#{language}.txt", "w")

      i = 0
      vocabulary.each do |k, v|
        line = "#{k}\t#{v[:tf]}\t#{v[:df]}\n"
        print "\rwriting #{i}"
        file.write(line)
        i += 1
      end

      print "\r"
    end

  end

  task :pair_profimedia_and_wiki_data do
    SUPPORTED_LANGUAGES.each do |language|
      wiki_data_path = "#{File.dirname(__FILE__)}/../../data/wiki_freq_list_#{language}.txt"
      profimedia_data_path = "#{File.dirname(__FILE__)}/../../data/tf_df_list_#{language}.txt"

      words = Hash.new(0)

      File.open(wiki_data_path).each do |line|
        c = line.split("\t")
        if c.size == 2
          words[c[0]] = c[1].to_i
        end
      end

      #output format
      #stem tf_profimedia df_profimedia tf_wiki
      file = File.open("#{File.dirname(__FILE__)}/../../data/paired_wiki_and_profimedia_#{language}.txt", "w")

      File.open(profimedia_data_path).each do |line|
        line = line.chomp
        if line.length > 0
          c = line.split("\t")

          #puts words[c[0]]
          line += "\t#{words[c[0]]}\n"

          file.write(line) if c[0].size > 0
        end
      end
    end
  end

  task :create_word_dictionary => :environment do

    #33265 words untranslated
    #google poznal named entities
    #musel jsem pouzit memsource
    #preklad na webu googlu prelozil jen 10 procent slov
    #google translator tools ma omezeni na 1 MB
    #musel jsem zrušit kapitalizeci, google napriklad vracel psČ;odstÁvČata, chovnÍ bĚhouni
    #odstranění interpunkce
    #obcas byla pomichana diakritika z jineho kodovani "boles?aw boles? aw", polske 'l'




    SUPPORTED_LANGUAGES.each do |language|

      next if language == PRIMARY_LANGUAGE

      tool = LanguageTool.new(language)

      path_source = "#{File.dirname(__FILE__)}/../../data/word_list.txt"
      path_target = "#{File.dirname(__FILE__)}/../../data/word_list_translated_#{language}.txt"

      dictionary_path = "#{File.dirname(__FILE__)}/../../data/word_dictionary_#{PRIMARY_LANGUAGE}_#{language}.txt"
      write_file = File.open(dictionary_path, "w")

      lines_source = File.readlines(path_source)
      lines_target = File.readlines(path_target)

      puts lines_source.size
      puts lines_target.size

      0.upto(lines_target.size - 1) do |i|
        source_word = lines_source[i].chomp
        target_word = lines_target[i].chomp

        target_word = source_word if target_word.size == 0

        target_word = tool.lowercase_line(target_word)

        target_word.gsub!(/[[:punct:]]/, "")
        target_word.strip!

        line = "#{source_word}\t#{target_word}\n"

        write_file.write(line)
      end
    end

  end

  task :test => :environment do
    name = "pokus"
    es_client = Elasticsearch::Client.new
    es_client.indices.delete index: name if es_client.indices.exists index: name
    es_client.indices.create index: name, body: {
      settings: {
        analysis: {
          analyzer: {
            ngram: {
              tokenizer: 'whitespace',
              #filter: ['lowercase', 'ngram'],
              type: 'custom'
            }
          }
        }
      },
      mappings: {
        clanek: {
          properties: {
            title: {
                type: 'string',
                index_analyzer: 'ngram',
                search_analyzer: 'ngram'
            }
          }
        }
      }
    }

    es_client.index index: name, type: "clanek", body: {
      title: "hello world"
    }

    es_client.indices.refresh

    #puts es_client.search index: name, type: "clanek", q: "title:hello"

    result = es_client.search index: name, type: "clanek", body: {
      query: {
        bool: {
          should: {
            term: {
              title: "helloo"
            }
          }
        }
      }
    },
    analyzer: "whitespace"

    puts result
  end

end