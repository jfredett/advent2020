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
