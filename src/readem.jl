function readem()
dimbase=1024
pmax=5
DataC=zeros(11,5,2)
loadme(fmt::String) = @eval @load($fmt)
for ip=1:pmax
gridlev=512 * (2^ip)
mixedpfile = string("Old_Data/Float16/paper", string(gridlev), ".jld")
loadme(mixedpfile)
DataC[:,ip,1]=fout16.exactout.ithist
DataC[:,ip,2]=fout16.fdout.ithist
end
testiow("F16c0.99old",DataC)
return DataC
end

