# class ClassReflection(T)
#   def self.new(subclass : X, *params, **tuple) forall X
#     {% if X <= T.class %}
#       subclass.new(*params, **tuple)
#     {% else %}
#       {% raise "#{X} should inherit from #{T.class}" %}
#     {% end %}
#   end
# end

# abstract class A
# end

# class B < A
#   def initialize(@x : Int32, b : Int32)
#   end
# end

# class C
# end

# x = ClassReflection(A)
# puts x.new(B, 1, 2)
# # puts x.new(C)

# # abstract class A
# #   abstract def render : Nil
# # end

# # class X < A
# #   def render
# #   end
# # end

# # class Test
# #   @@some_class = A

# #   def initialize(sub_elm : A = @@some_class.new)
# #     pp sub_elm
# #     sub_elm.render
# #   end
# # end

# # Test.new
