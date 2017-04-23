abstract class TreeTemplate::Renderer
  getter level : Int32 = 0

  def initialize
  end

  def sub_level(&block) : self
    @level += 1
    yield
    @level -= 1

    self
  end

  abstract def clear : Void

  abstract def concat(s : String)
end
