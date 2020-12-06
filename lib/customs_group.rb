require 'customs_declaration'

# A group of customs declarations
class CustomsGroup
  attr_accessor :entries

  def initialize(entries = [])
    @entries = entries
  end

  def member_count
    @entries.length
  end

  def all_declarations
    @entries.reduce(&:union)
  end

  def common_declarations
    @entries.reduce(&:intersection)
  end

  def total_declarations
    self.all_declarations.length
  end

  def total_common_declarations
    self.common_declarations.length
  end
end

