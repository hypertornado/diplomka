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

    SUPPORTED_LANGUAGES.each do |language|

      tool = LanguageTool.new(language)

      words = Hash.new(0)

      Dir.entries("#{File.dirname(__FILE__)}/../../data/wiki_#{language}").each do |dirname|
        if dirname[0] != "."
          Dir.entries("#{File.dirname(__FILE__)}/../../data/wiki_#{language}/#{dirname}").each do |file|
            if file[0] != "."
              export_wiki_words tool, words, "#{File.dirname(__FILE__)}/../../data/wiki_#{language}/#{dirname}/#{file}"
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
      File.write("#{File.dirname(__FILE__)}/../../data/wiki_freq_list_count_#{language}.txt", sum)

    end
  end

  def export_wiki_words language_tool, words_hash, filepath
    puts filepath
    File.open(filepath, 'r:utf-8').each do |line|
      if (!line.start_with?("<doc") and !line.start_with?("</doc"))
        language_tool.tokenize(line).each do |word|
          if word.length > 2
            word = language_tool.lowercase_line word
            words_hash[language_tool.stem_word(word)] += 1
          end
        end
      end
    end
  end

end