require 'data'
require 'vm'

Result.output for: 'day8' do
  parse! do |line|
    Instruction.new(line.chomp)
  end

  vm = VM.new(data)

  part 1, "Acc after infinite loop" do vm.run! end
  part 2, "Acc after repair" do
    VM.try_repair!(data).filter do |vm|
      result, _ = *vm.run!
      result == :repaired!
    end[0].acc
  end
end

