require_relative "import_line.rb"

ES_INDEX = "diplomka"

namespace :es do

  #extract first cca 10000 articles
  #words: 9231894
  task :extract_words_from_wiki do
    system("rm -rf #{File.dirname(__FILE__)}/../../data/wiki")
    system("cat #{File.dirname(__FILE__)}/../../data/wiki_dump.xml | python #{File.dirname(__FILE__)}/../WikiExtractor.py -b 250K -o #{File.dirname(__FILE__)}/../../data/wiki")
  end

  task :frequency_list_from_wiki do

    words = Hash.new(0)

    Dir.entries("#{File.dirname(__FILE__)}/../../data/wiki").each do |dirname|
      if dirname[0] != "."
        Dir.entries("#{File.dirname(__FILE__)}/../../data/wiki/#{dirname}").each do |file|
          if file[0] != "."
            export_wiki_words words, "#{File.dirname(__FILE__)}/../../data/wiki/#{dirname}/#{file}"
          end
        end
      end
    end

    out_file = File.open("#{File.dirname(__FILE__)}/../../data/wiki_freq_list.txt", "w")

    sum = 0

    words.each do |k,v|
      #puts "#{k} #{v}"
      out_file.write("#{k}\t#{v}\n")
      sum += v
    end
    puts "Total number of words: #{sum}"

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

  task :import do
    #around 20 M images
    path = "#{File.dirname(__FILE__)}/../../data/profi-text-cleaned.csv"
    #path = "#{File.dirname(__FILE__)}/../../data/tiny"

    puts "Importing data to elasticsearch - #{Time.now}"
    src_encoding = "Windows-1252"
    target_encoding = "utf-8"

    es_client = Elasticsearch::Client.new
    #clear_type(es_client, ES_INDEX, "image")

    i = 0
    File.open(path).each do |line|
      print "\r#{i}"
      line = line.encode(target_encoding, src_encoding)
      i += 1
      if ImportLine.valid? line
        ImportLine.new(line).es_import(es_client, ES_INDEX)
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

