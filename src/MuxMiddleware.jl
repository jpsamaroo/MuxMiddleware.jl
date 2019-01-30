module MuxMiddleware

using Mux

export hostbranch, regexbranch

"""
    hostbranch(host::AbstractString, app...)

Branches to `app...` when the request's hostname matches `host` exactly.
"""
hostbranch(host::AbstractString, app...) = branch(app...) do req
    req_host_all = first(filter(hdr->hdr[1]=="Host", req[:headers]))[2]
    # FIXME: Strip protocol?
    req_host = first(split(req_host_all, ":"))
    return host == req_host
end

"""
    regexbranch(regex::Regex, app...)

Branches to `app...` when `regex` matches the request path. The path will
always start with a '/'. If the regex matches, the RegexMatch result will be
stored in the request's `:regex_match` field.
"""
regexbranch(regex::Regex, app...) = branch(app...) do req
    matches = match(regex, "/" * join(req[:path], "/"))
    matches === nothing && return false
    req[:regex_match] = matches
    return true
end


end # module
