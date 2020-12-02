class TaskData
  include Enumerable
  extend Forwardable

  delegate :each => :@parsed

  def initialize(day)
    @path = "./data/#{day}.txt"
    @parsed = []
  end

  # line oriented parsing for now. We'll see if we need to change that later.
  def parse!
    File.read(@path).each_line do |line|
      @parsed << yield(line)
    end
  end
end
