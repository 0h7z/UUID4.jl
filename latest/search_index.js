var documenterSearchIndex = {"docs":
[{"location":"#UUID4.jl","page":"Manual","title":"UUID4.jl","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"(Image: CI status) (Image: codecov.io)","category":"page"},{"location":"","page":"Manual","title":"Manual","text":"","category":"page"},{"location":"#Usage","page":"Manual","title":"Usage","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"pkg> registry add https://github.com/0h7z/0hjl.git\npkg> add UUID4\n\njulia> using UUID4\nhelp?> UUID4\nhelp?> uuid","category":"page"},{"location":"","page":"Manual","title":"Manual","text":"","category":"page"},{"location":"#API-reference","page":"Manual","title":"API reference","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"Modules = [UUID4]\nOrder   = [:module]","category":"page"},{"location":"#UUID4.UUID4","page":"Manual","title":"UUID4.UUID4","text":"UUID4\n\nThis module provides universally unique identifier (UUID) version 4, along with related functions.\n\n\n\n\n\n","category":"module"},{"location":"#Types","page":"Manual","title":"Types","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"Modules = [UUID4]\nOrder   = [:constant, :type]","category":"page"},{"location":"#UUID4.Maybe","page":"Manual","title":"UUID4.Maybe","text":"Maybe{T} -> Union{Nothing, T}\n\n\n\n\n\n","category":"type"},{"location":"#UUID4.UUID","page":"Manual","title":"UUID4.UUID","text":"UUID -> Base.UUID\n\n\n\n\n\n","category":"type"},{"location":"#Functions","page":"Manual","title":"Functions","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"Modules = [UUID4]\nOrder   = [:function, :macro]","category":"page"},{"location":"#UUID4.uuid","page":"Manual","title":"UUID4.uuid","text":"uuid(rng::Random.AbstractRNG = Random.RandomDevice()) -> UUID\n\nGenerate a version 4 (random or pseudo-random) universally unique identifier (UUID), as specified by RFC 4122.\n\nExamples\n\njulia> rng = Random.MersenneTwister(42);\n\njulia> uuid(rng)\nUUID(\"bc8f8f98-a497-45c4-817b-b034d1a24a0e\")\n\n\n\n\n\n","category":"function"},{"location":"#UUID4.uuid4","page":"Manual","title":"UUID4.uuid4","text":"uuid4 -> uuid\n\n\n\n\n\n","category":"function"},{"location":"#UUID4.uuid_formats-Tuple{}","page":"Manual","title":"UUID4.uuid_formats","text":"uuid_formats() -> Vector{Int}\n\nReturn all 7 supported UUID string formats.\n\n# case-sensitive\n22 # (base62) 22\n24 # (base62) 7-7-8\n# case-insensitive\n25 # (base36) 25\n29 # (base36) 5-5-5-5-5\n32 # (base16) 32\n36 # (base16) 8-4-4-4-12\n39 # (base16) 4-4-4-4-4-4-4-4\n\n\n\n\n\n","category":"method"},{"location":"#UUID4.uuid_parse","page":"Manual","title":"UUID4.uuid_parse","text":"uuid_parse(str::AbstractString; fmt::Int = ncodeunits(str)) -> Tuple{Int, UUID}\n\n\n\n\n\n","category":"function"},{"location":"#UUID4.uuid_string","page":"Manual","title":"UUID4.uuid_string","text":"uuid_string(id::UUID = uuid()) -> Dict{Int, String}\nuuid_string(id::UUID = uuid(), T) -> T{Int, String} where T <: AbstractDict\nuuid_string(id::UUID = uuid(), fmt::Int) -> String\n\nExamples\n\njulia> uuid_string(OrderedDict, \"123e4567-e89b-12d3-a456-426614174000\")\nOrderedDict{Int64, String} with 7 entries:\n  22 => \"0YQJpYwUwvbaLOwTUr4thA\"\n  24 => \"0YQJpYw-UwvbaLO-wTUr4thA\"\n  25 => \"12vqjrnxk8whv3i8qi6qgrlz4\"\n  29 => \"12vqj-rnxk8-whv3i-8qi6q-grlz4\"\n  32 => \"123e4567e89b12d3a456426614174000\"\n  36 => \"123e4567-e89b-12d3-a456-426614174000\"\n  39 => \"123e-4567-e89b-12d3-a456-4266-1417-4000\"\n\n\n\n\n\n","category":"function"},{"location":"#UUID4.uuid_tryparse","page":"Manual","title":"UUID4.uuid_tryparse","text":"uuid_tryparse(s::AbstractString) -> Maybe{Union{UInt128, UUID}}\n\n\n\n\n\n","category":"function"},{"location":"#UUID4.uuid_version","page":"Manual","title":"UUID4.uuid_version","text":"uuid_version(id::AbstractString) -> Int\nuuid_version(id::UUID)           -> Int\n\nInspect the given UUID or UUID string and return its version (see RFC 4122).\n\nExamples\n\njulia> uuid_version(uuid())\n4\n\n\n\n\n\n","category":"function"}]
}