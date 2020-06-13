"""
This thing converts the old JLD2 stuff into the more stable JLD.

When I find the time I put the whole works into csv for long-term stability.

You must use this from the REPL and to 

import JLD2
import JLD

before you start.
 
"""
function convertjld()
oldfiles=readdir()
for fold in oldfiles
    fname=findfirst('j',fz) 
    if typeof(fname) != nothing
        fnew=string(fold[1:fname-1],"jld")
        @JLD2.load fold fout32 fout64
        @JLD.save fnew fout32 fout64
    end
end
end

function convert16jld()
oldfiles=readdir()
for fold in oldfiles
    fname=findfirst('j',fz)
    if typeof(fname) != nothing
        fnew=string(fold[1:fname-1],"jld")
        @JLD2.load fold fout16
        @JLD.save fnew fout16
    end
end
end

