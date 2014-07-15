namespace :es do

  task :import_image_metadata => :environment do
    path = "#{File.dirname(__FILE__)}/../../data/profi-text-cleaned.csv"

    puts "Importing data to elasticsearch - #{Time.now}"
    src_encoding = "Windows-1252"
    target_encoding = "utf-8"

    index_name = IMAGES_ES_INDEX

    es_client = Elasticsearch::Client.new
    
    language_tools = {}
    SUPPORTED_LANGUAGES.each do |language|
      language_tools[language] = LanguageTool.new(language)
    end

    es_client.indices.delete index: index_name if es_client.indices.exists index: index_name
    es_client.indices.create index: index_name, body: {
      settings: {
        analysis: {
          analyzer: {
            ngram: {
              tokenizer: 'whitespace',
              type: 'custom'
            }
          }
        }
      },
      mappings: {
        clanek: {
          properties: {
            stems_cs: {
                type: 'string',
                index_analyzer: 'ngram',
                search_analyzer: 'ngram'
            },
            stems_en: {
                type: 'string',
                index_analyzer: 'ngram',
                search_analyzer: 'ngram'
            }
          }
        }
      }
    }

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
        ImportLine.new(line).es_import(es_client, index_name, language_tools)
      end
    end
    es_client.indices.refresh
    print "\r"
    puts "Import ended - #{Time.now}"
  end

  task :import_word_data => :environment do

    es_client = Elasticsearch::Client.new
    index_name = STEMS_ES_INDEX

    es_client.indices.delete index: index_name if es_client.indices.exists index: index_name
    es_client.indices.create index: index_name

    SUPPORTED_LANGUAGES.each do |language|
      paired_file = "#{File.dirname(__FILE__)}/../../data/paired_wiki_and_profimedia_#{language}.txt"
      i = 0
      File.open(paired_file).each do |line|
        line.chomp!
        entries = line.split("\t")
        print "\r#{language} #{i}   "
        es_client.index index: index_name, type: language, id: entries[0], body: {
          tf: entries[1].to_i,
          df: entries[2].to_i,
          wiki: entries[3].to_i
        }
        i += 1
      end
      puts "\r"

      es_client.indices.refresh

    end

  end

  task :count_sum_of_wikipedia_words do
    wiki_data_path = "#{File.dirname(__FILE__)}/../../data/paired_wiki_and_profimedia.txt"

    system("cat #{wiki_data_path} | cut -f 4 | awk '{s+=$1} END {print s}'")

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

