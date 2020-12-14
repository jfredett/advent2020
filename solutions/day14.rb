class Array
  # from https://rosettacode.org/wiki/Power_set#Ruby
  #
  # Wouldn't be ruby without a little monkey patching.
  def powerset
    # Injects into a blank array of arrays.
    # acc is what we're injecting into
    # you is each element of the array
    inject([[]]) do |acc, you|
      ret = []             # Set up a new array to add into
      acc.each do |i|      # For each array in the injected array,
        ret << i           # Add itself into the new array
        ret << i + [you]   # Merge the array with a new array of the current element
      end
      ret       # Return the array we're looking at to inject more.
    end
  end
end

class DockingVM
  def initialize
    @memory = {}
    @version = 1
    @positive_mask = 0xFFFFFF
    @negative_mask = 0xFFFFFF
    @floating_mask_set = []
  end

  def set_mode!(version: 1)
    @version = version
  end

  def run!(instruction)
    instruction.send(:"#{instruction.type}_apply!", self)
  end

  def []=(addr, arg)
    if version? 1
      @memory[addr] = (arg | @positive_mask) & @negative_mask
    elsif version? 2
      base_addr = addr | @positive_mask
      @floating_mask_set.each do |x_mask|
        @memory[base_addr ^ x_mask] = arg
      end
    else
      raise "Unknown version: #{@version}"
    end

    nil
  end

  def set_mask(pm, nm, fm = [])
    @positive_mask = pm
    @negative_mask = nm
    @floating_mask_set = fm
  end

  def version?(v)
    @version == v
  end

  attr_reader :memory
end

class DockingInstruction
  WRITE = :write
  MASK = :mask

  attr_reader :type

  def initialize(raw)
    @raw = raw
    parse!
  end


  def parse!
    # note the spaces around the '='
    operator, operand = @raw.split(" = ")

    case operator
    when /mem\[(\d+)\]/
      @type = WRITE
      @addr = $1.to_i
      @arg = operand.to_i
    when /mask/
      @type = MASK
      # these are a little ugly but they work
      bit_list = operand.chars.map.with_index do |b, p|
        if b != "X"
          [2**(35 - p), b.to_i]
        end
      end.reject(&:nil?)

      x_list = operand.chars.map.with_index do |b, p|
        if b == "X"
          [2**(35 - p), :X]
        end
      end.reject(&:nil?)

      @positive_mask = bit_list.map { |v, b| (b * v) }.sum
      @negative_mask = ~bit_list.map { |v, b| (1 - b) * v }.sum
      # A list of masks which must all be applied on write
      @floating_mask_set = x_list.map { |v, _| v }.powerset.map(&:sum)
    else
      raise "Unrecognized instruction: #{@raw}"
    end
  end


  def write_apply!(vm)
    vm[@addr] = @arg
  end

  def mask_apply!(vm)
    vm.set_mask(@positive_mask, @negative_mask, @floating_mask_set)
  end

end


Result.output for: 'day14' do
  parse! do |line|
    DockingInstruction.new(line.chomp)
  end

  test "Basic Masking" do
    value = 11
    pos_mask = 64
    neg_mask = ~2

    ((value | pos_mask) & neg_mask) == 73
  end


  test "Simple v2 program" do
    program = %Q{mask = 000000000000000000000000000000X1001X\nmem[42] = 100\nmask = 00000000000000000000000000000000X0XX\nmem[26] = 1}
    instructions = program.split("\n").map { |i| DockingInstruction.new(i) }

    vm = DockingVM.new
    vm.set_mode! version: 2
    instructions.each do |i|
      vm.run!(i)
    end

    vm.memory.values.sum == 208
  end


  part 1, "Memory Values" do
    vm = DockingVM.new

    data.each do |i|
      vm.run!(i)
    end

    vm.memory.values.sum
  end

  part 2, "Floating Memory Values" do
    vm = DockingVM.new
    vm.set_mode! version: 2

    data.each do |i|
      vm.run!(i)
    end

    vm.memory.values.sum
  end
end
