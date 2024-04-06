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

using OrderedCollections: LittleDict, OrderedDict
using Random: Random
using Test, UUID4

u4 = uuid4()
@test 4 == uuid_version(u4)
@test 4 == uuid_version(u4 |> string)
@test 4 == uuid_version(u4 |> string |> GenericString)
@test 4 == uuid_version(u4 |> string |> s -> replace(s, "-" => ""))
@test u4 == UUID(string(u4)) == UUID(GenericString(string(u4)))
@test u4 == UUID(UInt128(u4))
@test uuid4(MersenneTwister(0)) == uuid4(MersenneTwister(0))
@test_throws ArgumentError UUID("550e8400e29b-41d4-a716-446655440000")
@test_throws ArgumentError UUID("550e8400e29b-41d4-a716-44665544000098")
@test_throws ArgumentError UUID("z50e8400-e29b-41d4-a716-446655440000")

# https://github.com/JuliaLang/julia/issues/35860
Random.seed!(Random.GLOBAL_RNG, 10)
@sync u4 = uuid4()
Random.seed!(Random.GLOBAL_RNG, 10)
@test u4 ≠ uuid4()

str = "22b4a8a1-e548-4eeb-9270-60426d66a48e"
@test_throws ArgumentError UUID("22b4a8a1ae548-4eeb-9270-60426d66a48e")
@test_throws ArgumentError UUID("22b4a8a1-e548a4eeb-9270-60426d66a48e")
@test_throws ArgumentError UUID("22b4a8a1-e548-4eeba9270-60426d66a48e")
@test_throws ArgumentError UUID("22b4a8a1-e548-4eeb-9270a60426d66a48e")
@test UUID(uppercase(str)) == UUID(str)
for r ∈ rand(UInt128, 10^3)
	s = string(UUID(r))
	@test UUID(r) == UUID(s)
	@test ncodeunits(s) === length(s) === 36
end

fmt = [22, 24, 25, 29, 32, 36, 39]
vec = [
	fmt[1] => "50XjbNooVpOszESTWcsJDk"
	fmt[2] => "50XjbNo-oVpOszE-STWcsJDk"
	fmt[3] => "9qr1zsf8wf3fn8st1t5r8hh1s"
	fmt[4] => "9qr1z-sf8wf-3fn8s-t1t5r-8hh1s"
	fmt[5] => "a4929835c612495983c50ac8e9265490"
	fmt[6] => "a4929835-c612-4959-83c5-0ac8e9265490"
	fmt[7] => "a492-9835-c612-4959-83c5-0ac8-e926-5490"
]
d_o, d_u = OrderedDict(vec), Dict(vec)
u = UUID(d_u[36])
s = GenericString(string(u))

@test uuid_tryparse("") |> isnothing
@test uuid_parse(s) == uuid_parse(u) == (36, u)
@test uuid_formats() == d_o.keys == fmt
for n ∈ fmt
	@test (n, u) == uuid_parse(d_u[n]) == uuid_parse(d_u[n] |> GenericString)
	@test d_u[n] == uuid_string(n, u) == uuid_string(u, n |> UInt32) == d_o[n]
	@test d_o[n] == uuid_string(n, u |> string) == uuid_string(u |> string, n)
	@test n == uuid_parse(uuid_string(n))[1]
end

@test_throws ArgumentError uuid_parse(d_u[32], fmt = -1)
@test_throws ArgumentError uuid_parse(d_u[32], fmt = 42)
@test_throws ArgumentError uuid_parse(d_u[32]^2)

@test uuid_string(u, LittleDict) == uuid_string(LittleDict, u)
@test uuid_string(u, OrderedDict) == uuid_string(OrderedDict, u)
@test uuid_string(u) == uuid_string(Dict, u) == d_u == Dict(d_o)
@test uuid_string(u) == uuid_string(s, Dict) == uuid_string(Dict, s)
@test_throws ArgumentError uuid_string(u, -1)
@test_throws ArgumentError uuid_string(u, 42)

