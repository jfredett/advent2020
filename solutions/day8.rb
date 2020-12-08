require 'data'

class Instruction
  attr_accessor :operation, :argument
  def initialize(code)
    @raw_code = code
    parse!
  end

  def parse!
    op, arg = *@raw_code.split(' ')
    @operation = op.to_sym
    @argument = arg.to_i
  end

  def execute!(context: nil)
    raise "must provide a VM to execute the instruction on" if context.nil?

    case self.operation
    when :nop
      context.pid += 1
    when :acc
      context.acc += self.argument
      context.pid += 1
    when :jmp
      context.pid += self.argument
    else
      raise "Unrecognized instruction #{self}"
    end
  end
end


class VM
  attr_accessor :pid, :acc

  def initialize(program)
    @program = program
    @seen_addresses = Set.new
    @pid = 0
    @acc = 0
  end

  def run!
    # run instructions until we repeat one
    until @seen_addresses.include?(@pid)
      # get the current instruction, then execute it on ourselves.
      current_instruction = @program[@pid]
      @seen_addresses << @pid
      current_instruction.execute!(context: self)
    end
    @acc
  end

end


data = TaskData.new('day8')


data.parse! do |line|
  Instruction.new(line.chomp)
end

vm = VM.new(data.parsed)

puts "Part 1 | Acc after infinite loop: #{vm.run!}"

#puts "Test 1 | Gold Bag Contents: #{test.count_gold_bag_contents!}"
#puts "Part 2 | Gold Bag Contents: #{group.count_gold_bag_contents!}"
binding.pry
