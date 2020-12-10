require 'data'
require 'matrix'


Result.output for: 'day10' do
  parse! do |line|
    line.chomp.to_i
  end

  SMALL_TEST_SET = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]

  def find_diffs(input)
    sorted = ([0] + input).sort

    groups = sorted.zip(sorted[1..] << sorted[-1] + 3).map{ |x,y| y - x }.group_by { |x| x }
    groups[1].length * groups[3].length
  end

  # this is less straightforward, the algorithm probably goes something like:
  #
  # 1. Start at 0, remove it from the list.
  # 2. Find all available options that branch from, i.e., that are within 1,
  #    or 3 jolts.
  # 3a. Recurse until we run out of possible children, if there are none return '1'
  # 3b. If there are more children, calculate their sum
  #
  # Something like:
  #
  # chain is the current chain we've built, input is the total input dataset
  def configurations_for(chain, input)
    # Assume input sorted, contains 0 and highest adapter rating at position 0
    # and -1 resp.
    point = chain[-1]

    # everything that is 1, 2, or 3 away from the point
    #children = input.filter { |x| (x - point) <= 3 && x != point }

    #return 1 if children.empty?

    # Recursion won't work because we don't tail-call optimize, we'll have to do
    # it our damn selves.
    #children.map { |c| configurations_for(chain + [c], input) }.sum

    chains = [[0]]
    count = 0
    iters = 0
    until chains.empty?
      new_chains = []
      chains.each do |chain|
        point = chain[-1]
        children = input.filter { |x| x > point && (x - point) <= 3 }
        if children.empty?
          count += 1
        else
          new_chains += children.map { |c| chain + [c] }
        end
      end
      iters += 1
      chains = new_chains

      if iters % 10 == 0
        puts "Chains so far: #{chains.length}"
      end
    end
    count
  end

  test "Jolt Difference Small Example" do
    find_diffs(SMALL_TEST_SET) == 35
  end

  test "Jolt Configurations Small Example -- Direct calculation" do
    input = SMALL_TEST_SET + [SMALL_TEST_SET.max + 3]
    configurations_for([0], input.sort) == 8
  end

  def dagify(input)
    h = {}
    input.each do |i|
      h[i] = input.filter { |e| e > i && (e - i).abs <= 3 }
    end
    h
  end

  def count_configurations(input)
    dag = dagify input
    size = input.max + 1
    m = Matrix.build(size) do |r,c|
      if (dag[r] || []).include? c
        1
      else
        0
      end
    end

    id = Matrix::I(size)

    (id - m).inv[0,input.max].to_i
  end

  test "Jolt Configurations Small Example -- Matrix Method" do
    input = SMALL_TEST_SET + [0] + [SMALL_TEST_SET.max + 3]

    count_configurations(input) == 8
  end


  part 1, "Jolt Differences" do
    # first round is pretty easy to do
    find_diffs(data)
  end


  part 2, "Jolt Configurations" do
    input = data + [0] + [data.max + 3]
    count_configurations(input)
  end
end

__END__

The direct-calculation approach is unlikely to work. Probably what needs to be done is to look at the entire sequence and count the number of ways it could be perturbed and still be a valid configuration. We know the 'fullest' configuration is the sorted set with appropriate appendages.

  If we instead start with the fullest configuration, then systematically _remove_ and then _check_, we could enumerate all possible configurations that way much more quickly.

So, imagine:

[0,1,2,3,4,5,8] remove any of the values in [1..-2], then check if it's valid

[0,2,3,4,5,8] is
[0,3,4,5,8] is
[0,4,5,8] is not

if we have a class calculate it's children, it can simply count by summing it's children's count of it's children, plus itself.

--- 

That's all clever, but it turns out it's also slow, it's probably a cipher of the recursive method.

Another idea is to identify 'chunks' -- bits of the chain that are present in all chains. This would reduce the search space a bunch.

Maybe there's an interval arithmetic thing here, consider: 

(0), 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19, (22)
(0), 1, 4, 5, 6, 7, 10, 12, 15, 16, 19, (22)
(0), 1, 4, 5, 7, 10, 11, 12, 15, 16, 19, (22)
(0), 1, 4, 5, 7, 10, 12, 15, 16, 19, (22)
(0), 1, 4, 6, 7, 10, 11, 12, 15, 16, 19, (22)
(0), 1, 4, 6, 7, 10, 12, 15, 16, 19, (22)
(0), 1, 4, 7, 10, 11, 12, 15, 16, 19, (22)
(0), 1, 4, 7, 10, 12, 15, 16, 19, (22)


In this, [0,1,4] is a chunk, as is [16,19,22]. Only the internal bits need changing. Maybe even just recognizing the fore-and-aft chunks'd be sufficient, but there might be chunks in the middle that can be used as well.

Here's a third (fourth?) strategy -- think of the chain(s) as a graph. We can model this as a hash like this:

Keys are the adapters, values are lists of other adapters that can follow it. Thus, `hash.keys` = V and `hash.values` = E. This graph is directed and acyclic, so we can meaningfully count the number of paths to the bottom. We can do this efficiently by noting:

0 is the common start point, there are `h[0]` branches from that start point. For any point in a chain, if there are `x` total chains as of that point, there are `x * h[p]` (where `p` is the point in the chain) additional chains created.

So, if your set is `[0,1,2,3,5]`, then you have

      h = {
        0 => [1,2,3]
        1 => [2,3]
        2 => [3]
        3 => [5]
      }

the algorithm is then just a visitor algorithm a la the original naive approach, but should be somewhat quicker since we aren't constructing chains, just counting them.

  The visitor thing didn't quite work, but we can use the DAG to find the minimimum chain. Probably I should go with the adjacency matrix idea below, but basically take the root, then the maximum of the roots neighbors, then so on until you have no more items. That's the shortest possible chain. The longest is the same but take the minimum at each step.

  So how to think about this.

    {
      0=>[1],
      1=>[4],
      4=>[5, 7, 6],
      5=>[7, 6],
      6=>[7],
      7=>[10],
      10=>[11, 12],
      11=>[12],
      12=>[15],
      15=>[16], 
      16=>[19],
      19=>[22],
      22=>[]
    }

This is the 'small' set from the problem, it should have 8 possible values. We could build the adj matrix from this. I don't see any obvious factorization in that list (multiplying everything together gets you 12, not 8 as needed). Maybe an inverted version?

    {
      22 => [19]
      19 => [16]
      16 => [15],
      15 => [12],
      12 => [10,11]
      11 => [10],
      10 => [7],
      7  => [6,5,4],
      6  => [5,4],
      5  => [4],
      4  => [1],
      1  => [0],
      0  => []
    }

fuck it, Adj matrix time
