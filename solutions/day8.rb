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
      if @pid >= @program.length
        if @pid = @program.length + 1
          return [:repaired!, @acc]
        else
          return [:not_repaired, @acc]
        end
      end
      # get the current instruction, then execute it on ourselves.
      current_instruction = @program[@pid]
      binding.pry if current_instruction.nil?
      @seen_addresses << @pid
      current_instruction.execute!(context: self)
    end
    [:repeated, @acc]
  end

  # the idea is going to be to try changing _every_ nop/jmp, one at a time, for
  # a given program.
  def self.try_repair!(program)
    vms = []
    program.length.times do |idx|
      # deep-clones are kinda hard.
      new_program = Marshal.load(Marshal.dump(program))
      case program[idx].operation
      when :acc
        next
      when :nop
        new_program[idx].operation = :jmp
        vms << VM.new(new_program)
      when :jmp
        new_program[idx].operation = :nop
        vms << VM.new(new_program)
      end
    end
    vms
  end
end


data = TaskData.new('day8')


data.parse! do |line|
  Instruction.new(line.chomp)
end

vm = VM.new(data.parsed)

puts "Part 1 | Acc after infinite loop: #{vm.run!}"

part2 = VM.try_repair!(data.parsed).filter do |vm|
  result, _ = *vm.run!
  result == :repaired!
end
puts "Part 2 | Acc after repair: #{part2[0].acc}"
