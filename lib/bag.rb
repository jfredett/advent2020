require 'bag_group'
require 'bag_rule'

def mk_bag_group(day)
  data = TaskData.new(day)
  data.parse! do |line|
    BagRule.new(line.chomp)
  end

  BagGroup.new(data.to_a)
end
