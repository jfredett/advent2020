class DockingVM
  def initialize
    @memory = {}
    @positive_mask = 0xFFFFFF
    @negative_mask = 0xFFFFFF
  end

  def run!(instruction)
    instruction.send(:"#{instruction.type}_apply!", self)
  end

  def []=(addr, arg)
    @memory[addr] = (arg | @positive_mask) & @negative_mask
  end

  def set_mask(pm, nm)
    @positive_mask = pm
    @negative_mask = nm
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
      bit_list = operand.chars.map.with_index do |b, p| 
        if b != "X"
          [2**(35 - p), b.to_i]
        end
      end.reject(&:nil?)

      @positive_mask = bit_list.map { |v, b| (b * v) }.sum
      @negative_mask = ~bit_list.map { |v, b| (1 - b) * v }.sum
    else
      raise "Unrecognized instruction: #{@raw}"
    end
  end


  def write_apply!(vm)
    vm[@addr] = @arg
  end

  def mask_apply!(vm)
    vm.set_mask(@positive_mask, @negative_mask)
  end

end


Result.output for: 'day14' do
  parse! do |line|
    DockingInstruction.new(line.chomp)
  end

  test "Test Masking" do
    value = 11
    pos_mask = 64
    neg_mask = ~2

    ((value | pos_mask) & neg_mask) == 73
  end

  part 1, "Memory Values" do
    vm = DockingVM.new

    data.each do |i|
      vm.run!(i)
    end

    vm.memory.values.sum
  end
end
