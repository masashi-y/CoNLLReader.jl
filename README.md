
##CoNLLReader.jl
very flexible CoNLLReader

```julia
using CoNLLReader
# created Token object with fields id, words, tag, ctag, head, label
@CoNLLReader.format id::Int word::String :- tag::String ctag::String :- head::Int label::String :- :-

# also can specify function to preprocess the fields
@CoNLLReader.format id::Int (word::String, lowercase) :- tag::String ctag::String :- head::Int label::String :- :-


sents = CoNLLReader.read(Token, "../corpus/wsj_23.conll")
> Vector{Vector{Token}}
```
