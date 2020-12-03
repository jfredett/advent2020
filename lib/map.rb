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
