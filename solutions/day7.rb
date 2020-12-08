require 'data'
require 'bag'

group = mk_bag_group('day7')
test = mk_bag_group('day7-test')

Result.output do
  part 1, "Gold Bag Containers" do group.find_gold_bags!.length end
  test "Gold Bag Contents method works" do test.count_gold_bag_contents! == 126 end
  part 2, "Gold Bag Contents" do group.count_gold_bag_contents! end
end
