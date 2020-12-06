# A single declaration
class CustomsDeclaration
  extend Forwardable
  include Enumerable

  delegate [:length, :[], :each] => :@declaration
  delegate [:intersection, :union, :|] => :@declaration

  attr_accessor :declaration

  def initialize(declaration)
    @declaration = Set.new(declaration.chars)
  end

end
