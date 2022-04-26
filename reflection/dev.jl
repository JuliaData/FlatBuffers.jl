using FlatBuffers

include("reflection.jl")


##

buf = open(read,"test/monster/monster.bfbs")

schema = FlatBuffers.getrootas(Reflection.Schema_, buf, 0);


##

code = """
module Foo

struct Bar
end

end

"""