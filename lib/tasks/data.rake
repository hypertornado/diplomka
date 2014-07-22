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


    SUPPORTED_LANGUAGES.each do |language|
      correct = 0
      file_count = Dir["#{File.dirname(__FILE__)}/../../train_data/#{language}/*"].size / 2
      puts "STARTING #{language}, #{file_count} files"
      1.upto(file_count) do |n|
        name = (1000 + n).to_s[1,3]
        text = File.read("#{File.dirname(__FILE__)}/../../train_data/#{language}/#{name}.txt")
        test_keywords = File.read("#{File.dirname(__FILE__)}/../../train_data/#{language}/#{name}.keywords").split("\n")
        puts " #{name}---"

        tool = LanguageTool.new(language)
        api = Api.new "", [], language
        keywords = api.keywords text

        keywords = keywords[0, 5]


        keywords.map! {|w| w[0]}
        test_keywords.map! {|w| tool.stem_word(w)}

        puts "   found: #{(keywords & test_keywords).join(" ")}"
        puts "  nfound: #{(test_keywords - keywords).join(" ")}"
        puts "  wfound: #{(keywords - test_keywords).join(" ")}"
        
        correct += 5 - (test_keywords - keywords).size
      end

      puts " CORRECT (#{language}): #{correct} / #{5 * file_count}\n\n"
    end
  end

  task :random_text_data => :environment do
    limit = 60

    path = "#{File.dirname(__FILE__)}/../../data/idn"
    files = Dir["#{path}/*"]
    files = files.shuffle
    files = files[0, limit]
    files.map! {|f| f[-12,5]}
    puts files.inspect
  end

  task :generate_random_ids => :environment do
    randomids = []
    
    0.upto(100) do |i|
     random_id = get_random_image_id
     randomids.push random_id
     puts "#{i} #{random_id}"
    end
    puts ""
    puts ""
    puts randomids.inspect
  end

  task :export_ids => :environment do
    path = "#{File.dirname(__FILE__)}/../../data/profi-text-cleaned.csv"
    export_path = "#{File.dirname(__FILE__)}/../../data/profi-text-cleaned.csv"
    out = File.open("#{File.dirname(__FILE__)}/../../data/image_ids.txt", "w")

    i = 0
    File.open(path).each do |line|
      print "\r#{i}"
      i += 1
      out.write("#{line[1,10]}\n")
    end
  end

  task :test_data => :environment do

    users = ["o_paroubkova", "o_havel", "o_rakosova", "o_pavlovic", "o_semerad"]

    user_pairs = []

    users.each do |u1|
      users.each do |u2|
        if u1 != u2
          3.times {user_pairs.push([u1, u2])}
        end
      end
    end

    user_pairs.each do |pair|
      #puts pair[0]
      #puts pair[1]
      #puts "#{pair[0]} #{pair[1]}"
    end

    #puts user_pairs.size

    output = ""

    html = ""

    random_ids = ["0007210728", "0001030712", "0041312880", "0077542194", "0034225897", "0008882893", "0049331239", "0004657841", "0034607988", "0007116667", "0049069897", "0004124310", "0034636007", "0012010063", "0005671936", "0009050414", "0013182570", "0013524080", "0050401132", "0003369549", "0013226103", "0004492880", "0048275307", "0012759043", "0005607702", "0004148425", "0070814828", "0013639720", "0006874931", "0004051776", "0054317658", "0007862751", "0051027003", "0007008568", "0049959256", "0034638408", "0051888928", "0002761475", "0001037071", "0037681449", "0034819424", "0014373576", "0014427382", "0053691113", "0007833088", "0003324475", "0055478413", "0069819686", "0001295674", "0055938828", "0004543724", "0009402234", "0050536437", "0013717136", "0034717479", "0013290311", "0002383477", "0008761051", "0006398919", "0005371062", "0002029419", "0006280846", "0049917699", "0011676175", "0012817885", "0013712337", "0004194075", "0070444145", "0049602848", "0051021582", "0005046286", "0013813821", "0008370559", "0007572140", "0070674998", "0002151723", "0012547160", "0001263354", "0014322390", "0043729399", "0005585127", "0008491311", "0049029786", "0033923632", "0077369620", "0034590042", "0034378350", "0005352734", "0051066739", "0005513537", "0010890842", "0048332485", "0013674547", "0034383289", "0001211520", "0005997426", "0013982195", "0009247483", "0011354122", "0003168067", "0048316409", "0077531417"]

    i = 0
    base_path = "#{File.dirname(__FILE__)}/../../data/idn"
    ids = ["06752", "01758", "08781", "04947", "08752", "10076", "03907", "07822", "07084", "07792", "08036", "00207", "00070", "13448", "12051", "15157", "14610", "05449", "01089", "15232", "02412", "02211", "02059", "09018", "14008", "01921", "07732", "04566", "05640", "03615", "01337", "07757", "14737", "03202", "03430", "09399", "01595", "13294", "15513", "04025", "12442", "09817", "04107", "09093", "09237", "04151", "15282", "12471", "04900", "00881", "03758", "06945", "09551", "07604", "14972", "02343", "14539", "12605", "03901", "01853"]
    ids.each do |id|
      path = "#{base_path}/idn-#{id}.txt.gz"

      pair = user_pairs.shift

      #puts "ID: #{id}"
      Zlib::GzipReader.open(path) do |gz|
        text = gz.readlines.join("\n")
        api = Api.new text, [], "cs"
        html += "<h1>#{id}</h1>"
        html += text
        html += "<br>"
        results_ids = []
        results_ids.push(random_ids.shift)
        results = api.search(0, 4)
        results["hits"]["hits"].each do |hit|
          results_ids.push hit["_id"]
        end

        results_ids = results_ids.shuffle

        img_paths = results_ids.map {|p| "mufin_images/#{p}"}

        pair.each do |user|
          #mufin_images
          line = "#{300000 + i} o_test1 0 #{user} ./text/idn/idn-#{id}.txt.gz #{img_paths.join(';')}"
          puts line
          i += 1
        end

        results_ids.each do |ri|
          html += "<img src=\"http://mufin.fi.muni.cz/profimedia/bigImages/#{ri}\" height=200>"
        end
      end
    end

    file = File.open("#{File.dirname(__FILE__)}/../../public/test.html", "w")
    file.write(html)

  end

end

def get_random_image_id
  es_client = Elasticsearch::Client.new
  size = (es_client.search index: IMAGES_ES_INDEX, body: {})["hits"]["total"]
  ret = es_client.search index: IMAGES_ES_INDEX, body: {
    size: 1,
    from: rand(size)
  }

  return ret["hits"]["hits"][0]["_id"]
end

