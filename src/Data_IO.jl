function readmpdata(fname,data)
open(fname,"r") do io
read!(io,data)
end
end

function writempdata(fname,data)
open(fname,"w") do io
write(io, data)
end
end

function Fname(c,T)
if T==Float64
   fname=string("F3264c",string(c))
else
   fname=string("F16c",string(c))
end
return fname
end
