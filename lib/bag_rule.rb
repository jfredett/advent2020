# specifies a rule about what bags it can contain
class BagRule
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
