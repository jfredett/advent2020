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
