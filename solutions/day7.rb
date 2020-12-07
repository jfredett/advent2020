require 'data'


# specifies a rule about what bags it can contain
class BagRule
  extend Forwardable

  delegate [:each, :filter] => :contained_colors

  def initialize(rule_text)
    @rule_text = rule_text
    parse_rule!
  end

  def color
    @parent_color
  end

  def contents
    @content_rules
  end

  def contained_colors
    Set.new(@content_rules.keys)
  end

  private

  def parse_rule!
    antecedent, consequent = *@rule_text.split("contain")

    @parent_color = antecedent.chop.split('bags')[0].chop
    @content_rules = {}

    if consequent !~ /no other bags/
      consequent.split(',').each do |rule|
        matches = /(?<qty>(\d+|no)) (?<color>\D+) bags?\.?/.match(rule)

        @content_rules[matches[:color]] = matches[:qty].to_i
      end
    end
  end
end

# contains a bunch of bag-rules and lets you traverse them
class BagGroup
  SHINY_GOLD = 'shiny gold'

  def initialize(rules)
    @rules = {}

    rules.each do |rule|
      @rules[rule.color] = rule
    end
  end

  # to do this, we should start by finding anything that contains a gold bag
  # then we loop over everything and find all the colors that contain any of the
  # colors we found, repeat until no new bags are added.

  def find_gold_bags!
    # Find the set of bags that can directly contain a SHINY_GOLD bag.
    gold_bags = Set.new @rules.values.filter { |e| e.contents.include?(SHINY_GOLD) }.map(&:color)

    # Do a transitive closure, finding all bags that can contain a bag which
    # contains a bag which ...
    stabilized = false
    until stabilized
      initial_size = gold_bags.length

      @rules.each do |color, contents|
        color_contents = contents.contained_colors

        # If any of the contained colors are in the set of bags we know can
        # contain a gold bag
        if color_contents.intersect? gold_bags
          # add in the new parent color
          gold_bags << color
        end
      end

      stabilized = gold_bags.length == initial_size
    end

    gold_bags
  end

  def count_gold_bag_contents!
    # Start at gold bag, visit it's children and add to the tally
    neighbors = [SHINY_GOLD]
    # this starts at -1 because we don't count the first bag.
    qty = -1

    until neighbors.empty?
      next_neighbor = @rules[neighbors.shift]

      next_neighbor.each do |color, count|
        count.times { neighbors << color }
      end
      qty += 1
    end

    qty
  end
end


def bag_group(day)
  data = TaskData.new(day)
  data.parse! do |line|
    BagRule.new(line.chomp)
  end

  BagGroup.new(data.to_a)
end

group = bag_group('day7')
test = bag_group('day7-test')


puts "Part 1 | Gold Bag Containers: #{group.find_gold_bags!.length}"
puts "Test 1 | Gold Bag Contents: #{test.count_gold_bag_contents!}"
puts "Part 2 | Gold Bag Contents: #{group.count_gold_bag_contents!}"
