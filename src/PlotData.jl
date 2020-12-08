"""
data_harvest(all=true)
Makes all the figures from the paper for the notebook.
This function calls PlotData to make the figures one at a time.
"""
function data_harvest(all=true)
cvals = [.5, .99, 1]
itvals = [10, 10, 30]
level=5
for ic=1:3
    figure(ic)
    PlotData(cvals[ic])
end
if all
for ic=1:3
    figure(ic+3)
    PlotData(cvals[ic]; half=true)
end
end
end

"""
PlotData(c; half=false, level=5, ptitle=true)

Generates a figure from the paper using the precomputed data from
data_populate. 
"""


function PlotData(c; half=false, level=5, ptitle=true)
if half
   nfig=2
   T=Float16
   TI=[Float16]
   leadtitle="Half Precision: c = "
else
   nfig=4
   T=Float64
   TI=[Float64, Float32]
   leadtitle="Single and Double Precision: c = "
end
ftitle=string(leadtitle,string(c))
c==1.0 ? (nits=31) : (nits=11)
maxit=nits-1
#aymin=1.e-15
aymin=ymin(c,half)
Datain=zeros(nits,level,nfig)
fname=Fname(c,T)
readmpdata(fname, Datain)
for T in TI
PlotHist(Datain, level, maxit, aymin, T)
end
if ptitle
   PyPlot.suptitle(ftitle)
end
end


function ymin(c, half)
    ymin = 1.e-15
    if half
        if c == 1.0
            ymin = 1.e-6
        elseif c == .99
            ymin = 1.e-10
        end
    end
    return ymin
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

