
##CoNLLReader.jl
very flexible CoNLLReader

```julia
using CoNLLReader
# created Token object with fields id, words, tag, ctag, head, label
@CoNLLReader.format Token id::Int word::String :- tag::String ctag::String :- head::Int label::String :- :-

# columns with :- are ignored, if you don't need ctag
@CoNLLReader.format Token id::Int word::String :- tag::String :- :- head::Int label::String :- :-

# also can specify function to preprocess the fields
@CoNLLReader.format Token id::Int (word::String, lowercase) :- tag::String ctag::String :- head::Int label::String :- :-

sents = CoNLLReader.read(Token, "../corpus/wsj_23.conll")
> Vector{Vector{Token}}

# creates print function which prints the token in CoNLL format
# with ignored fields replaced with "_"
for token in sents[1]
    println(token)
end
```
