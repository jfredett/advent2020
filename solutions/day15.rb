class Sequence
  def initialize(starting_numbers)
    # map from idx -> number
    @cache = {}
    # map from number -> idx(es)
    @index = {}
    @pointer = starting_numbers.length - 1

    starting_numbers.each.with_index do |n,idx|
      @cache[idx] = n
      @index[n] ||= []
      @index[n] << idx
    end

  end

  # [idx] == value from the `n+1`th turn
  def [](idx)
    return @cache[idx] if @cache.has_key? idx
    while @pointer != idx
      previous_entry = @cache[@pointer]

      @pointer += 1

      if first_mention? previous_entry
        @cache[@pointer] = 0
        @index[0] << @pointer
      else
        a, b = *@index[previous_entry][-2..-1]
        @cache[@pointer] = b - a
        @index[b - a] ||= []
        @index[b - a] << @pointer
      end

    end

    @cache[idx]
  end

  # convenience
  def turn(idx)
    self[idx - 1]
  end


  def first_mention?(v)
    @index.has_key? v and @index[v].length == 1
  end


end



Result.output for: 'day15' do
  parse! do |line|
    line.to_i
  end

  test "Example Sequence" do
    seq = Sequence.new([0,3,6])

    seq[3] == 0 and seq[4] == 3 and
    seq[5] == 3 and seq[6] == 1 and
    seq[7] == 0 and seq[8] == 4 and
    seq[2019] == 436
  end

  part 1, "2020th number in the sequence" do
    seq = Sequence.new(data)
    seq.turn(2020)
  end

  part 2, "30000000th number in the sequence" do
    seq = Sequence.new(data)
    seq.turn(30000000)
  end

end
