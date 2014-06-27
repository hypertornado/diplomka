namespace :trigrams do

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
  
end