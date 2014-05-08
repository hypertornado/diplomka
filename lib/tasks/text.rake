namespace :text do

#find text -name "*.gz" | xargs gzip -d
    
  task :export do
    Dir.entries("#{File.dirname(__FILE__)}/../../data/text").each do |dirname|
      if dirname[0] != "."
        Dir.entries("#{File.dirname(__FILE__)}/../../data/text/#{dirname}").each do |path|
          if path.end_with?(".html")
            name = path.split(".").first
            puts name
            in_path = "#{File.dirname(__FILE__)}/../../data/text/#{dirname}/#{name}.html"
            out_path = "#{File.dirname(__FILE__)}/../../data/text/#{dirname}/#{name}.justext"
            system("python -m justext -s Czech -o #{out_path} #{in_path}")
          end
        end
      end
    end
  end

  task :clean do
    system("mkdir #{File.dirname(__FILE__)}/../../data/text_cleaned 2>/dev/null")
    Dir.entries("#{File.dirname(__FILE__)}/../../data/text").each do |dirname|
      if dirname[0] != "."
        system("mkdir #{File.dirname(__FILE__)}/../../data/text_cleaned/#{dirname} 2>/dev/null")
        clean dirname
      end
    end
  end

  def clean dir

    frequencies = Hash.new(0)

    Dir.entries("#{File.dirname(__FILE__)}/../../data/text/#{dir}").each do |path|
      if path.match(/[0-9]\.txt/)
        text = File.read("#{File.dirname(__FILE__)}/../../data/text/#{dir}/#{path}")
        #puts path
        #puts text.size
        lines = text.split("\n")
        lines.each do |line|
          new_line = fix_line line
          frequencies[line] += 1
        end
      end
    end

    #result = frequencies.sort_by {|_key, value| value}

    #result.reverse! 

    #puts result[0,10]

    Dir.entries("#{File.dirname(__FILE__)}/../../data/text/#{dir}").each do |path|
      if path.match(/[0-9]\.txt$/)
        puts path
        new_content = ""
        text = File.read("#{File.dirname(__FILE__)}/../../data/text/#{dir}/#{path}")
        lines = text.split("\n")
        duplicities = Hash.new(0)
        lines.each do |line|
          old_line = line
          new_line = fix_line line
          break if detected_footer?(old_line)
          if (frequencies[new_line] <= 5 and duplicities[new_line] == 0 and text_line?(new_line))
            new_content += "#{old_line}\n"
          end
          duplicities[new_line] = 1
        end
        new_content = fix_text new_content
        File.open("#{File.dirname(__FILE__)}/../../data/text_cleaned/#{dir}/#{path}.cleaned", 'w') { |file| file.write(new_content) }
      end
    end

  end

  def fix_line line
    line.strip!
    line = line.gsub(/[0-9]/,"")
    return line
  end

  def text_line? line
    return false if line.match(/^Autor\: /)
    return false if line.match(/^Autoři\: /)
    return false if line.match(/^Autor článku/)
    return false if line.match(/^Autor působí/)
    return false if line.match(/^Autor pracuje/)
    return false if line.match(/^Autor je/)
    return false if line.match(/^Zdroj\:/)
    return false if line.match(/\|.*\|/)
    return false if line.match(/^větší obrázek Autor:/)
    return false if line.match(/^ url: /)
    return false if line.match(/Podívejte se.*Podívejte se.*Podívejte se/)
    return false if line.match(/^\(.*\)$/)
    return false if line.match(/\— Autor: /)
    return false if line.match(/na serveru Alík.cz \- /)
    return false if line.match(/Témata článku\: /)
    return false if line.match(/ \– autor\: /)
    return false if line.match(/^Tagy\: /)
    return false if line.match(/^Foto\: /)
    return false if line.match(/^DÁLE ČTĚTE\: /)
    return true
  end

  def detected_footer? (line)
    return true if line.match(/Čtěte také\:/)
    return true if line.match(/Líbím se ti\? Tak mi hned ZAVOLEJ/)
    return true if line.match(/Autor článku:/)
    return true if line.match(/^Čtěte také$/)
    return true if line.match(/^Tisk Sdílet$/)
    return false
  end

  def fix_text text
    text = text.gsub(/[^\n]+\n[^\n]+… celý článek\n/, "")
    text = text.gsub(/[^\n]+\n[^\n]+…\n/, "")
    return text
  end

end

