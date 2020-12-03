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
    raise "Off the map" if y >= self.height
    @map[y][x % self.width]
  end

  def ride!(toboggan)
    trees = 0
    while toboggan.position[1] != self.height
      trees += 1 if self.tree_at?(toboggan)
      toboggan.slide!
    end
    return trees
  end

  def tree_at?(toboggan)
    self[*toboggan.position] == '#'
  end
end


class Toboggan
  attr_reader :run, :fall, :position

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
toboggan = Toboggan.new(3,1)

puts "Part 1 | Trees hit: #{map.ride!(toboggan)}"

