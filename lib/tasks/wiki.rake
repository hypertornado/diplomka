namespace :wiki do

  #extract first cca 10000 english articles
  #cca 20000 articles in czech
  #words: 9231894 in english
  task :extract_words_from_wiki, [:language] => :environment do |t, args|
    language = args[:language].to_s
    raise "not supported language #{language}" unless SUPPORTED_LANGUAGES.include?(language)
    puts "extracting wiki data for #{language} language"
    system("rm -rf #{File.dirname(__FILE__)}/../../data/wiki_#{language}")
    system("cat #{File.dirname(__FILE__)}/../../data/wiki_dump_#{language}.xml | python #{File.dirname(__FILE__)}/../WikiExtractor.py -b 250K -o #{File.dirname(__FILE__)}/../../data/wiki_#{language}")
  end


  task :frequency_list_from_wiki => :environment do

    #TODO, make czech here
    ["en"].each do |language|

      words = Hash.new(0)

      Dir.entries("#{File.dirname(__FILE__)}/../../data/wiki_#{language}").each do |dirname|
        if dirname[0] != "."
          Dir.entries("#{File.dirname(__FILE__)}/../../data/wiki_#{language}/#{dirname}").each do |file|
            if file[0] != "."
              export_wiki_words words, "#{File.dirname(__FILE__)}/../../data/wiki_#{language}/#{dirname}/#{file}"
            end
          end
        end
      end

      out_file = File.open("#{File.dirname(__FILE__)}/../../data/wiki_freq_list_#{language}.txt", "w")

      sum = 0

      words.each do |k,v|
        out_file.write("#{k}\t#{v}\n")
        sum += v
      end
      puts "Total number of words #{language}: #{sum}"

    end
  end

end