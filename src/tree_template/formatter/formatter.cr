require "io"

abstract class TreeTemplate::Formatter
  getter level : Int32 = 0

  def sub_level(&block) : self
    @level += 1
    yield
    @level -= 1

    self
  end

  abstract def <<(x)

  abstract def clear : Void

  abstract def concat(s : String)
end
