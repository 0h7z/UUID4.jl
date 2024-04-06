using Documenter: Documenter, DocMeta
using UUID4

DocMeta.setdocmeta!(UUID4, :DocTestSetup, quote
#! format: noindent
using OrderedCollections
using UUID4
end)

@info "doctest"
Documenter.doctest(UUID4, fix = true, manual = false)

@info "makedocs"
Documenter.makedocs(
	doctest   = false,
	format    = Documenter.HTML(),
	modules   = [UUID4],
	pages     = ["Manual" => "index.md"],
	pagesonly = true,
	sitename  = "UUID4.jl",
)

@info "deploydocs"
Documenter.deploydocs(
	devbranch = "master",
	devurl    = "latest",
	forcepush = true,
	repo      = "github.com/0h7z/UUID4.jl.git",
)

