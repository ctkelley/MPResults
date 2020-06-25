"""
heqtest(n=100, c=.5, printh="yes"; jprecision=Float64, jmaxit=10)

Generates the examples for the SIREV paper.
"""
function heqtest(n=100, c=.5, printh="yes"; jprecision=Float64, jmaxit=10)
FS=ones(n,)
x0=ones(n,)
setc(c)
hdata=heqinit(x0,n,jprecision)
FPS=ones(jprecision,n,n)
nsoldoutfd=nsold(x0, FS, FPS, heqf! ;
         atol=1.e-18, rtol=1.e-18, pdata=hdata, maxit=jmaxit)
nsoldoutex=nsold(x0, FS, FPS, heqf!, heqJ!; 
         atol=1.e-18, rtol=1.e-18, pdata=hdata, maxit=jmaxit)
if printh == "yes"
sol=nsoldoutex.solution
cpout = chandprint(sol,hdata)
for i=1:21
@printf("%1.2e      %1.5e \n",cpout[i,1], cpout[i,2])
end
@printf("\n \n \n")
println(nsoldoutex.ithist)
end
return (exactout=nsoldoutex, fdout=nsoldoutfd)
end

