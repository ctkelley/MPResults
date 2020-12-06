function PlotData(c; half=false, level=5)
half ? (nfig=2; T=Float16) : (nfig=4; T=Float64);
c==1.0 ? (nits=31) : (nits=11)
Datain=zeros(nits,level,nfig)
fname=Fname(c,T)
testior(fname, Datain)
println(Datain)
end


function Fname(c,T)
if T==Float64
   fname=string("F3264c",string(c))
else
   fname=string("F16c",string(c))
end
return fname
end

function testior(fname, data)
open(fname,"r") do io
read!(io,data)
end
end
