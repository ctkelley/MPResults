"""
data_populate(c=.5; half=false, level=5)
"""
function data_populate(c=.5; half=false, level=5)
fmtplot = ("k-", "k--", "k-.", "k-.", "k>:")
dimbase=1024
aymin=1.e-15
half ? (T=Float16) : (T=Float64)
c==1.0 ? (maxit=30) : (maxit=10)
if T == Float16
DataC=zeros(maxit+1,level,2)
BuildHist!(DataC,dimbase, c, level, maxit, T)
else
DataC=zeros(maxit+1,level,4)
for TI in (Float64, Float32)
    BuildHist!(DataC,dimbase, c, level, maxit, TI)
end
end
fname=Fname(c,T)
writempdata(fname,DataC)
end

function BuildHist!(DataC,dimbase, c, pmax, maxit, T)
if T==Float16
pstart=1
else
pstart = (T==Float32)*3 + (T==Float64)*1
end
for p=0:pmax-1
n=dimbase*(2^p)
dout=heqtest(n, c, "no"; jprecision=T, jmaxit=maxit)
DataC[:,p+1,pstart].=dout.exactout.history
DataC[:,p+1,pstart+1].=dout.fdout.history
end
end
