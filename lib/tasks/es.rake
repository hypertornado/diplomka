namespace :es do

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
  client.indices.refresh
end

