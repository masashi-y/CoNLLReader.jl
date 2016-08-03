module CoNLLReader

export BaseToken, format, read
typealias String AbstractString

macro format(t_name, args...)
    token_t = :(type $t_name end)
    token_fields = token_t.args[3].args
    init = parse("""function $t_name(line::AbstractString)
            items = split(strip(line), "\t")
    end""")
    init_args = init.args[2].args
    init_res = :($t_name())
    printfunc = parse("""function Base.print(io::IO, token::$t_name)
            print(io, join([], "\t"))
    end""")
    printargs = Any[]
    for i = 1:length(args)
        arg = args[i]
        if typeof(arg) == Expr && arg.args[1] == :-
            push!(printargs, "_")
            continue
        elseif typeof(arg) == Symbol
            var_name = arg
            push!(token_fields, arg)
            push!(init_args, :($var_name = items[$i]))
        elseif arg.head == :(::)
            push!(token_fields, arg)
            var_name = arg.args[1]
            if eval(arg.args[2]) <: Number
                arg_type = arg.args[2] 
                push!(init_args, :($var_name = parse($arg_type, items[$i])))
            else
                push!(init_args, :($var_name = items[$i]))
            end
        elseif typeof(arg) == Expr && arg.head == :tuple
            field = arg.args[1]
            func = arg.args[2]
            var_name = typeof(field) == Symbol ? arg : arg.args[1]
            push!(token_fields, field)
            push!(init_args, :($var_name = $func(items[$i])))
        else
            throw("$(i)th column not valid: $arg")
        end
        push!(printargs, :(token.$var_name))
        push!(init_res.args, var_name)
    end
    push!(init_args, init_res)
    printfunc.args[2].args[2].args[3].args[2].args = printargs # args for join
    # eval(token_t)
    # eval(init)
    # eval(printfunc)
    quote
        $(esc(token_t))
        $(esc(init))
        $(esc(printfunc))
    end
end

macro WSJ(t_name)
    # t_name = esc(t_name)
    text = "@format $t_name id::Int word::ASCIIString :- tag::ASCIIString ctag::ASCIIString :- head::Int label::ASCIIString :- :-"
    exp = "export $t_name"
    quote
        eval(parse($text))
        eval(parse($exp))
    end
end

function read(::Type, filename::AbstractString)
    res = Vector{Token}[[]]
    for line in open(readlines, filename)
        if length(line) < 3
            push!(res, []); continue
        end
        push!(res[end], Token(line))
    end
    res = filter(s -> length(s) > 0, res)
    res
end

end
