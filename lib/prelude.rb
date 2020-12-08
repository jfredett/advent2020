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

  def self.output(&block)
    instance_eval(&block)
  end
end


