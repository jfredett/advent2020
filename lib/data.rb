class TaskData
  include Enumerable
  extend Forwardable

  delegate [:length, :[], :each] => :parsed

  attr_accessor :parsed

  def initialize(day)
    @path = "./data/#{day}.txt"
    @parsed = []
  end

  # line oriented parsing for now. We'll see if we need to change that later.
  def parse!
    File.read(@path).each_line do |line|
      self.add_parsed_entry!(yield(line))
    end
  end

  # Just give me the whole input and I'll do whatever with it
  def custom_parse!
    self.add_parsed_entry! yield(File.read(@path))
  end

  def each_line(&block)
    # TODO: Make this a forwarded method
    File.read(@path).each_line(&block)
  end

  def parse_by_chunk!
    File.read(@path).split("\n\n").each do |chunk|
      self.add_parsed_entry!(yield(chunk))
    end
  end

  def add_parsed_entry!(entry)
    @parsed << entry
  end
end
