require 'data'
require 'customs'

data = TaskData.new('day6')


data.parse_by_chunk! do |chunk|
  entries = chunk.split("\n")

  CustomsGroup.new( entries.map { |e| CustomsDeclaration.new(e.chomp) } )
end


puts "Part 1 | Sum of all total declarations: #{data.map(&:total_declarations).sum}"
puts "Part 2 | Sum of all common declarations: #{data.map(&:total_common_declarations).sum}"
