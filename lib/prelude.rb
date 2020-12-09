require 'forwardable'
require 'pry'


# A cheap little thing for making my output look consistent
class Result
  def self.part(number, message)
    puts "Part #{number} | #{message}: #{yield} "
  end

  def self.test(message)
    @test_count ||= 0
    @test_count += 1
    if yield
      puts "Test #{@test_count} | ✓ | #{message}"
    else
      puts "Test #{@test_count} | ⤫ | #{message}"
    end
  end

  def self.output(opts = {}, &block)
    # TODO: refactor old days to match this.
    #raise 'invoke like: Result.output for: "day#"' if opts[:for].nil?
    if opts.has_key?(:for)
      @data = TaskData.new(opts[:for])
      @data_parsed = false
    end
    instance_eval(&block)
  end

  def self.parse!(&block)
    @data.parse!(&block)
    @data_parsed = true
  end

  def self.parse_by_chunk!(&block)
    @data.parse_by_chunk!(&block)
    @data_parsed = true
  end

  def self.data
    raise "don't forget to parse the data!" unless already_parsed?
    @data.parsed
  end

  def self.already_parsed?
    @data_parsed
  end
end
