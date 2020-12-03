require 'data'

class Map < TaskData
  attr_reader :map, :width, :height


  def initialize(*args)
    super
    @map = []

    parse! do |line|
      @map << line.chop!.chars
    end

    @width = @map[0].length
    @height = @map.length
  end

  def [](x,y)
    @map[y][x % self.width]
  end

  def ride!(toboggan)
    trees = 0
    while toboggan.position[1] < self.height
      trees += 1 if self.tree_at?(toboggan)
      toboggan.slide!
    end

    toboggan.performance = trees
  end

  def tree_at?(toboggan)
    self[*toboggan.position] == '#'
  end
end


class Toboggan
  attr_reader :run, :fall, :position

  attr_accessor :performance

  def initialize(run, fall)
    @position = [0,0]
    @run = run
    @fall = fall
  end

  def slide!
    @position = [self.position[0] + self.run, self.position[1] + self.fall]
  end
end

map = Map.new('day3')

toboggans = [
  Toboggan.new(1,1),
  Toboggan.new(3,1),
  Toboggan.new(5,1),
  Toboggan.new(7,1),
  Toboggan.new(1,2)
]


toboggans.each do |toboggan|
  map.ride!(toboggan)
end

part1_toboggan = toboggans[1]

puts map.height

puts "Part 1 | Trees hit: #{part1_toboggan.performance}"
puts "Part 2 | Product of Trees hit: #{toboggans.map(&:performance).reduce(&:*)}"





