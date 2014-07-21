namespace :similar do

  task :import => :environment do

    path = "/Volumes/ondra_zaloha/profi-neuralnet-20M.data.gz"

    #path = "/Users/ondrejodchazel/projects/diplomka/data/tiny.gz"
    
    index_name = SIMILAR_ES_INDEX
    es_client = Elasticsearch::Client.new


    es_client.indices.delete index: index_name if es_client.indices.exists index: index_name

    block_limit = 1000000
    max_limit = 10

    #sim = Similarity.new(max_limit)

    Zlib::GzipReader.open(path) do |gz|

      i = 0
      until (gz.eof? or i > block_limit) do
        print "\ri#{i}   "
        i += 1

        header = gz.readline
        vec = gz.readline

        #puts vec

        body = {
          vectors: Similarity.convert_vector(vec)
        }
        id = Similarity.parse_header_str(header)

        es_client.index index: index_name, type: "sim", id: Similarity.parse_header_str(header), body: body

        #sim.add_loaded header, vec
      end

    end

  end

end