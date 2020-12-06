require 'data'

data = TaskData.new('day6')

# A group of customs declarations
class CustomsGroup
  attr_accessor :entries

  def initialize(entries = [])
    @entries = entries
  end

  def member_count
    @entries.length
  end

  def declarations
    @entries.reduce(&:union)
  end

  def total_declarations
    self.declarations.length
  end
end

# A single declaration
class CustomsDeclaration
  extend Forwardable
  include Enumerable

  delegate [:length, :[], :each] => :@declaration
  delegate [:union, :|] => :@declaration

  attr_accessor :declaration

  def initialize(declaration)
    @declaration = Set.new(declaration.chars)
  end

end

data.parse_by_chunk! do |chunk|
  entries = chunk.split("\n")

  CustomsGroup.new( entries.map { |e| CustomsDeclaration.new(e.chomp) } )
end


puts "Part 1 | Sum of all declarations: #{data.map(&:total_declarations).sum}"
