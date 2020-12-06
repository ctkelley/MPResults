"""
mptest(c=.5; maxit=10, pmax=5, T=Float64, dsave=false)
"""
function mptest(c=.5; maxit=10, pmax=5, T=Float64, dsave=false)
fmtplot = ("k-", "k--", "k-.", "k-.", "k>:")
dimbase=1024
aymin=1.e-15
if T == Float16
DataC=zeros(maxit+1,pmax,2)
BuildHist!(DataC,dimbase, c, pmax, maxit, T)
PlotHist(DataC, pmax, maxit, aymin, T)
else
DataC=zeros(maxit+1,pmax,4)
for TI in (Float64, Float32)
    pstart = (TI==Float32)*3 + (TI==Float64)*1
    BuildHist!(DataC,dimbase, c, pmax, maxit, TI)
    PlotHist(DataC, pmax, maxit, aymin, TI)
end
end
~dsave || writehist(DataC, c, T, pmax, maxit)
return DataC
end

"""
data_populate(c=.5; maxit=10, pmax=5, T=Float64, dsave=false)
"""
function data_populate(c=.5; maxit=10, pmax=5, T=Float64)
fmtplot = ("k-", "k--", "k-.", "k-.", "k>:")
dimbase=1024
aymin=1.e-15
if T == Float16
DataC=zeros(maxit+1,pmax,2)
BuildHist!(DataC,dimbase, c, pmax, maxit, T)
else
DataC=zeros(maxit+1,pmax,4)
for TI in (Float64, Float32)
    BuildHist!(DataC,dimbase, c, pmax, maxit, TI)
end
end
writehist(DataC, c, T, pmax, maxit)
return DataC
end


function writehist(DataC, c, T,  pmax=5, maxit=10)
dimbase=1024
aymin=1.e-15
if T == Float16
filename=string("F16c",string(c))
else
filename=string("F3264c",string(c))
end
testiow(filename, DataC)
end

function storehist(c,pmax,maxit,T)
dimbase=1024
aymin=1.e-15
if T == Float16
DataC=zeros(maxit+1,pmax,2)
filename=string(T,"c",string(c))
#filename=string("F16c",string(c))
else
DataC=zeros(maxit+1,pmax,4)
filename=string(T,"c",string(c))
end
BuildHist!(DataC,dimbase, c, pmax, maxit, T)
testiow(filename,DataC)
end


function BuildHist!(DataC,dimbase, c, pmax, maxit, T)
if T==Float16
pstart=1
else
pstart = (T==Float32)*3 + (T==Float64)*1
end
for p=0:pmax-1
n=dimbase*(2^p)
dout=harvest(n, c, T, maxit)
DataC[:,p+1,pstart].=dout.dhiste
#println(dout.dhiste)
DataC[:,p+1,pstart+1].=dout.dhistfd
#println(dout.dhistfd)
end
end

function PlotHist(DataC::Array{Float64,3}, pmax, maxit, aymin, T)
fmtplot = ("k-", "k--", "k-.", "k-.", "k>:")
if T==Float16
b=1
pstart=1
else
b=2
pstart = (T==Float32)*3 + (T==Float64)*1
end
subplot(b,2,pstart)
for ip=1:pmax
semilogy(0:maxit,DataC[:,ip,pstart],fmtplot[ip])
axis([0.0, maxit, aymin, 1.0])
if pstart == 1
       legend(["1024", "2048", "4096", "8192", "16384"])
end
title(string(string(T)," analytic "))
end
subplot(b,2,pstart+1)
for ip=1:pmax
semilogy(0:maxit,DataC[:,ip,pstart+1],fmtplot[ip])
title(string(string(T)," finite difference"))
axis([0.0, maxit, aymin, 1.0])
end
end


function harvest(n, c, T, maxit)
dout=heqtest(n, c, "no"; jmaxit=maxit, jprecision=T)
dhiste=zeros(maxit+1,);
dhistfd=zeros(maxit+1,);
nel=length(dout.exactout.history)
nfl=length(dout.fdout.history)
dhiste[1:nel]=dout.exactout.history./dout.exactout.history[1]
dhistfd[1:nfl]=dout.fdout.history./dout.fdout.history[1]
if nfl != maxit+1 || nel != maxit+1
println("Iteration needs padding")
end
return(dhiste=dhiste, dhistfd=dhistfd)
end
