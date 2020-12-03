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
