

module Day12
  NORTH = :N
  SOUTH = :S
  EAST = :E
  WEST = :W
  LEFT = :L
  RIGHT = :R
  FORWARD = :F

  class Compass
    ROSE = [EAST, SOUTH, WEST, NORTH]


    def initialize(facing = EAST)
      @facing = 0
    end

    def left!(amt)
      rotate = amt / 90
      @facing = (@facing - rotate) % ROSE.length
      nil
    end

    def right!(amt)
      rotate = amt / 90
      @facing = (@facing + rotate) % ROSE.length
      nil
    end

    def facing
      ROSE[@facing].downcase
    end
  end

  class FerryInstruction
    attr_reader :dir, :arg

    def initialize(raw)
      @raw = raw
      @dir = raw[0].downcase.to_sym
      @arg = raw[1..].to_i
    end

    def apply!(to: nil)
      self.send(@dir, to)
    end

    def n(ferry)
      ferry.long += self.arg
    end

    def s(ferry)
      ferry.long -= self.arg
    end

    def e(ferry)
      ferry.lat += self.arg
    end

    def w(ferry)
      ferry.lat -= self.arg
    end

    def l(ferry)
      ferry.left!(arg)
    end

    def r(ferry)
      ferry.right!(arg)
    end

    def f(ferry)
      self.send(ferry.facing, ferry)
    end
  end

  class Ferry
    extend Forwardable

    delegate [:left!, :right!, :facing] => :@compass
    attr_accessor :lat, :long

    def initialize(waypoint: nil)
      @lat = 0
      @long = 0
      @compass = Compass.new
      @waypoint = waypoint
    end

    def run!(instruction)
      if @waypoint.nil?
        self.send(instruction.dir, instruction)
      else
        @waypoint.send(instruction.dir, instruction, self)
      end
    end

    def distance_from_origin
      @lat.abs + @long.abs
    end

    def n(instruction)
      self.long += instruction.arg
    end

    def s(instruction)
      self.long -= instruction.arg
    end

    def e(instruction)
      self.lat += instruction.arg
    end

    def w(instruction)
      self.lat -= instruction.arg
    end

    def l(instruction)
      left!(instruction.arg)
    end

    def r(instruction)
      right!(instruction.arg)
    end

    def f(instruction, towards: nil)
      # this changes if we're moving towards a waypoint or not
      if towards.nil?
        # If we don't have a waypoint, just drive forward
        self.send(facing, instruction)
      else
        # The waypoint provides our vector, so we adjust along it the
        # appropriate number of times
        instruction.arg.times do
          # these will be negative if appropriate
          dlat, dlong = *@waypoint.vector
          self.lat += dlat
          self.long += dlong
        end
      end
    end
  end

  class Waypoint
    extend Forwardable

    attr_accessor :lat, :long

    def initialize
      @lat = 10
      @long = 1
    end

    def vector
      [@lat, @long]
    end

    def run!(instruction)
      instruction.apply!(to: self)
    end

    def distance_from_origin
      @lat.abs + @long.abs
    end

    def n(instruction, ferry)
      self.long += instruction.arg
    end

    def s(instruction, ferry)
      self.long -= instruction.arg
    end

    def e(instruction, ferry)
      self.lat += instruction.arg
    end

    def w(instruction, feryy)
      self.lat -= instruction.arg
    end

    def l(instruction, ferry)
      (instruction.arg / 90).times do
        old_lat = @lat
        old_long = @long
        @lat = -old_long
        @long = old_lat
      end
    end

    def r(instruction, ferry)
      (instruction.arg / 90).times do
        old_lat = @lat
        old_long = @long
        @lat = old_long
        @long = -old_lat
      end
    end

    def f(instruction, ferry)
      ferry.f(instruction, towards: self)
    end

  end

  Result.output for: 'day12' do
    parse! do |line|
      FerryInstruction.new(line.chomp)
    end

    test "Compass works as expected" do
      facing_tests = []

      compass = Compass.new
      facing_tests << compass.facing == EAST

      compass.left!(90)
      facing_tests << compass.facing == NORTH

      compass.right!(90)
      facing_tests <<  compass.facing == EAST

      compass.right!(90)
      facing_tests << compass.facing == SOUTH

      compass.right!(270)
      facing_tests << compass.facing == EAST

      compass.left!(180)
      facing_tests << compass.facing == WEST

      facing_tests.all?
    end

    test "Direct-instruction-based Small Example" do
      instructions = ["F10", "N3", "F7", "R90", "F11"].map { |i| FerryInstruction.new(i) }
      ferry = Ferry.new
      instructions.each do |i|
        ferry.run!(i)
      end

      ferry.distance_from_origin == 25
    end

    part 1, "Direct-instruction-based Ferry Ride" do
      ferry = Ferry.new
      data.each do |i|
        ferry.run!(i)
      end

      ferry.distance_from_origin
    end

    test "Waypoint-based Small Example" do
      instructions = ["F10", "N3", "F7", "R90", "F11"].map { |i| FerryInstruction.new(i) }
      waypoint = Waypoint.new
      ferry = Ferry.new(waypoint: waypoint)

      instructions.each do |i|
        ferry.run!(i)
      end

      ferry.distance_from_origin == 286
    end

    part 2, "Waypoint-based Ferry Ride" do
      waypoint = Waypoint.new
      ferry = Ferry.new(waypoint: waypoint)

      data.each do |i|
        ferry.run!(i)
      end

      ferry.distance_from_origin
    end
  end

end
