# Copyright (C) 2022-2024 Heptazhou <zhou@0h7z.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""
	UUID4

This module provides universally unique identifier (UUID) version 4,
along with related functions.
"""
module UUID4

export uuid, uuid4

export uuid_formats
export uuid_parse
export uuid_string
export uuid_tryparse
export uuid_version

export AbstractRNG, MersenneTwister, RandomDevice
export UUID

const Maybe{T} = Union{Nothing, T}
const UUID = Base.UUID
using Random: AbstractRNG, MersenneTwister, RandomDevice

"""
	uuid(rng::AbstractRNG = Random.RandomDevice()) -> UUID

Generate a version 4 (random or pseudo-random) universally unique identifier (UUID),
as specified by [RFC 4122](https://tools.ietf.org/html/rfc4122).

# Examples
```jldoctest
julia> rng = MersenneTwister(42);

julia> uuid(rng)
UUID("bc8f8f98-a497-45c4-817b-b034d1a24a0e")
```
"""
function uuid(rng::AbstractRNG = RandomDevice())::UUID
	id = rand(rng, UInt128)
	id &= 0xffffffffffff0fff3fffffffffffffff
	id |= 0x00000000000040008000000000000000
	id |> UUID
end
const uuid4 = uuid

"""
	uuid_formats() -> Vector{Int}

Return all supported UUID string formats.
"""
function uuid_formats()::Vector{Int}
	[
		# case-sensitive
		22 # (base62) 22
		24 # (base62) 7-7-8
		# case-insensitive
		25 # (base36) 25
		29 # (base36) 5-5-5-5-5
		32 # (base16) 32
		36 # (base16) 8-4-4-4-12
		39 # (base16) 4-4-4-4-4-4-4-4
	]
end

"""
	uuid_parse(str::AbstractString; fmt::Int = ncodeunits(str)) -> Tuple{Int, UUID}
"""
function uuid_parse end
function uuid_parse(id::UUID)::Tuple{Int, UUID}
	(36, id)
end
function uuid_parse(str::AbstractString; fmt::Int = 0)::Tuple{Int, UUID}
	len = ncodeunits(str)
	(id = uuid_tryparse(str)) |> isnothing &&
		argumenterror("Invalid id `$str` with ncodeunits = $len")
	if 0 < fmt ≠ len
		argumenterror("Invalid id `$str` with ncodeunits = $len (should be $fmt)")
	elseif fmt < 0
		argumenterror("Invalid format `$fmt` (should be positive)")
	end
	len, id |> UUID
end

"""
	uuid_string(id::UUID = uuid()) -> Dict{Int, String}
	uuid_string(id::UUID = uuid(), T) -> T{Int, String} where T <: AbstractDict
	uuid_string(id::UUID = uuid(), fmt::Int) -> String

# Examples
```jldoctest
julia> uuid_string(OrderedDict, "123e4567-e89b-12d3-a456-426614174000")
OrderedDict{Int64, String} with 7 entries:
  22 => "0YQJpYwUwvbaLOwTUr4thA"
  24 => "0YQJpYw-UwvbaLO-wTUr4thA"
  25 => "12vqjrnxk8whv3i8qi6qgrlz4"
  29 => "12vqj-rnxk8-whv3i-8qi6q-grlz4"
  32 => "123e4567e89b12d3a456426614174000"
  36 => "123e4567-e89b-12d3-a456-426614174000"
  39 => "123e-4567-e89b-12d3-a456-4266-1417-4000"
```
"""
function uuid_string end
function uuid_string(::Type{T}, id::Any) where T <: AbstractDict
	uuid_string(uuid_parse(id)[end], T)
end
function uuid_string(id::Any, ::Type{T} = Dict) where T <: AbstractDict
	uuid_string(uuid_parse(id)[end], T)
end
function uuid_string(::Type{T}, id::UUID = uuid()) where T <: AbstractDict
	uuid_string(id, T)
end
function uuid_string(id::UUID = uuid(), ::Type{T} = Dict) where T <: AbstractDict
	id36 = string(id)
	id22 = string(id.value, base = 62, pad = 22)
	id25 = string(id.value, base = 36, pad = 25)
	id32 = string(id.value, base = 16, pad = 32)
	id24 = replace(id22, r"(.{7})" => s"\1-", count = 2)
	id29 = replace(id25, r"(.{5})" => s"\1-", count = 4)
	id39 = replace(id32, r"(.{4})" => s"\1-", count = 7)
	T(22 => id22, 24 => id24, 25 => id25, 29 => id29, 32 => id32, 36 => id36, 39 => id39)
end
function uuid_string(fmt::Number, id::Any)::String
	uuid_string(uuid_parse(id)[end], Int(fmt))
end
function uuid_string(id::Any, fmt::Number)::String
	uuid_string(uuid_parse(id)[end], Int(fmt))
end
function uuid_string(fmt::Int, id::UUID = uuid())::String
	uuid_string(id, fmt)
end
function uuid_string(id::UUID, fmt::Int)::String
	fmt ≤ 0 ?
	argumenterror("Invalid format `$fmt` (should be positive)") :
	fmt ≡ 36 ? string(id) :
	fmt ≡ 22 ? string(id.value, base = 62, pad = 22) :
	fmt ≡ 25 ? string(id.value, base = 36, pad = 25) :
	fmt ≡ 32 ? string(id.value, base = 16, pad = 32) :
	fmt ≡ 24 ? replace(uuid_string(id, 22), r"(.{7})" => s"\1-", count = 2) :
	fmt ≡ 29 ? replace(uuid_string(id, 25), r"(.{5})" => s"\1-", count = 4) :
	fmt ≡ 39 ? replace(uuid_string(id, 32), r"(.{4})" => s"\1-", count = 7) :
	argumenterror("Invalid format `$fmt` (not defined)")
end

"""
	uuid_tryparse(s::AbstractString) -> Maybe{Union{UInt128, UUID}}
"""
function uuid_tryparse end
let
#! format: noindent

function dropdash(str::AbstractString; step::Int, count::Int)
	for i ∈ 1:count
		@inbounds UInt8('-') ≠ codeunit(str, (1 + step)i) && return ""
	end
	replace(str, "-" => ""; count)
end

function uuid_tryparse(str::AbstractString)::Maybe{Union{UInt128, UUID}}
	len = ncodeunits(str)
	len ≡ 24 ? uuid_tryparse(dropdash(str, step = 7, count = 2)) :
	len ≡ 29 ? uuid_tryparse(dropdash(str, step = 5, count = 4)) :
	len ≡ 39 ? uuid_tryparse(dropdash(str, step = 4, count = 7)) :
	len ≡ 22 ? Base.tryparse(UInt128, str, base = 62) :
	len ≡ 25 ? Base.tryparse(UInt128, str, base = 36) :
	len ≡ 32 ? Base.tryparse(UInt128, str, base = 16) :
	len ≡ 36 ? Base.tryparse(UUID, str) : (nothing)
end

global uuid_tryparse
end

"""
	uuid_version(id::AbstractString) -> Int
	uuid_version(id::UUID)           -> Int

Inspect the given UUID or UUID string and return its version
(see [RFC 4122](https://tools.ietf.org/html/rfc4122)).

# Examples
```jldoctest
julia> uuid_version(uuid())
4
```
"""
function uuid_version end
uuid_version(id::Any)::Int  = uuid_version(uuid_parse(id)[end])
uuid_version(id::UUID)::Int = id.value >> 76 & 0xf |> Int

@noinline argumenterror(msg::AbstractString) = throw(ArgumentError(msg))

end # module

