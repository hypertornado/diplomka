class Similarity

  def initialize(limit)

    @loaded = {}

    @compared = Hash.new([])

    @limit = limit

  end

  def add_loaded l1, l2
    id = Similarity.parse_header(l1)
    vec = Similarity.parse_vector(l2)

    #puts "add_loaded #{id}"

    @loaded[id] = vec

  end

  def clear_loaded

    @loaded = {}

  end

  def add_compare l1, l2
    id = Similarity.parse_header(l1)
    vec = Similarity.parse_vector(l2)

    #puts "add_compare #{id}"

    @loaded.each do |k, v|

      val = Similarity.new_york(v, vec)

      @compared[id] = [] unless @compared.key? id

      if @compared[id].size < @limit or @compared[id].last[0] > val

        @compared[id].push([val, k])
        @compared[id].sort! {|a, b| a[0] <=> b[0]}
        @compared[id] = @compared[id][0, @limit]
      end
    end

  end

  def get_best id
    return @compared[id].map{|v| v[1]}
  end

  def print_it

    @compared.each do |k, v|
      puts "#{k} #{v.join('-')}"
    end
  end

  def self.parse_header_str line
    line.chomp!
    return line.split(" ")[2]
  end

  def self.parse_header_str line

    line.chomp!
    return line.split(" ")[2].to_i
  end

  def self.parse_vector line
    line.chomp!
    line.split(" ").map! {|e| e.to_f}
  end

  def self.convert_vector line
    line.chomp!
    r = 0
    ret = ""
    line.split(" ").each_with_index do |e, i|
      if e != "0.0"
        ret += "#{i} "
        r += 1
      end
    end
    return ret
  end

  def self.new_york v1, v2
    ret = 0.0
    0.upto(v1.size - 1) do |i|
      ret += (v1[i] - v2[i]).abs
    end
    return ret
  end

end