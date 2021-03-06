require 'data'
require 'customs'

data = TaskData.new('day6')


data.parse_by_chunk! do |chunk|
  entries = chunk.split("\n")

  CustomsGroup.new( entries.map { |e| CustomsDeclaration.new(e.chomp) } )
end

Result.output do
  part 1, "Sum of all total declarations" do data.map(&:total_declarations).sum end
  part 2, "Sum of all common declarations" do data.map(&:total_common_declarations).sum end
end
