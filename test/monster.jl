using FlatBuffers

@enum(Color, Red = 0, Green, Blue = 2)

immutable Vec3
    x::Float32
    y::Float32
    z::Float32
end
Vec3() = Vec3(0, 0, 0)

for nm in [:Weapon, :Monster]
    @eval begin
        type $nm <: FlatBuffers.Table
            io::FlatBuffers.TableIO
            memb::FlatBuffers.Membrs
        end

        $nm(io::IO, pos) = $nm(FlatBuffers.TableIO(io, pos), $(symbol(string(nm,"_members"))))
        $nm() = $nm(IOBuffer(zeros(UInt8,4)), 0)
    end
end

typealias Equipment Union{Weapon}

const Weapon_members = FlatBuffers.Membrs(
    :name => (4, UTF8String, ""),
    :damage => (6, Int16, 0)
  )

const Monster_members = FlatBuffers.Membrs(
     :pos => (4, Vec3, Vec3()),
     :mana => (6, Int16, 150),
     :hp => (8, Int16, 100),
     :name => (10, UTF8String, ""),
     :friendly => (12, Bool, false),
     :inventory => (14, Vector{UInt8}, UInt8[]),
     :color => (16, UInt8, Blue),
     :weapons => (18, Vector{Weapon}, Weapon[]),
     :equipped => (20, Equipment, nothing)
  )
