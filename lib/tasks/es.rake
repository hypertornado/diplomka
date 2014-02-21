require "elasticsearch"

namespace :es do

  task :import do
    #around 20 M images
    path = "/Users/ondrejodchazel/projects/diplomka_old/data/profi-text-cleaned.csv"
    #path = "/Users/ondrejodchazel/projects/diplomka_old/data/tiny"
    puts "Importing data to elasticsearch - #{Time.now}"
    src_encoding = "Windows-1252"
    target_encoding = "utf-8"
    index = "diplomka"

    es_client = Elasticsearch::Client.new
    es_client.indices.delete index: index if es_client.indices.exists index: index
    es_client.indices.create index: index

    i = 0
    File.open(path).each do |line|
      print "\r#{i}"
      line = line.encode(target_encoding, src_encoding)
      i += 1
      if ImportLine.valid? line
        ImportLine.new(line).es_import(es_client, index)
      end
    end
    es_client.indices.refresh
    print "\r"
    puts "Import ended - #{Time.now}"
  end

  task :start do
    puts "Starting elasticsearch"
    system("#{File.dirname(__FILE__)}/../../bin/elasticsearch/bin/elasticsearch")
  end

end

class ImportLine

  def initialize line

    raise "line not valid: " unless ImportLine.valid? line

    fields = split_fields line
    @locator = fields[0]
    @title = fields[1]
    @description = fields[2]
    @keywords = fields[3]

    #puts @keywords if @locator.match("736665")
  end

  def es_import client, index
    client.index index: index, type: "image", id: @locator, body: {
      locator: @locator,
      title: @title,
      description: @description,
      keywords: @keywords
    }

  end

  def split_fields line
    ret = line.scan(/"[^"]*"/)
    #remove first and last '"' chars
    ret.map do |el|
      el.chop[1..-1]
    end
  end

  def self.valid? line
    ret = false
    begin
      ret = true if line.match(/^"[0-9]+"/)
    rescue
      #this happens with bad encoding
      puts "line validation exception: #{line}"
    end

    return ret
  end

end
