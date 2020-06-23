"""
Heq4nsold

This module contains the Chandrasekhar H-equation examples
and everything you should need to run them.

It still has a couple global variables that I'm having trouble 
making go away.

If you only want to run the examples, you should not have to look
at the code.
"""
module Heq4nsold

global Gfix=[1.0;1.0]
global c=.5 

export heqf!
export heqJ!
export setc
export chandprint
export heqinit

using AbstractFFTs
using FFTW
using LinearAlgebra
using LinearAlgebra.BLAS

"""
function heqJ!(F,FP,x,pdata)

The is the Jacobian evaluation playing by nsold rules. The
precomputed data is a big deal for this one. 
"""
function heqJ!(F,FP,x,pdata)
global c
hseed=pdata.hseed
mu=pdata.mu
precision=typeof(FP[1,1])
n=length(x)
#
# Look at the formula in the notebook and you'll see what I did here.
#
Gfix=x-F
Gfix=-(c*n)*(Gfix.*Gfix.*mu)
@views @inbounds for jfp=1:n
    FP[:,jfp].=precision.(Gfix[:,1].*hseed[jfp:jfp+n-1])
#    FP[:,jfp].=precision.(Gfix[:,1].*hseed[jfp:jfp+n-1])
#     for ifp=1:n
#         fpij=Gfix[ifp]/(mu[ifp]+mu[jfp])
#         FP[ifp,jfp]=precision(fpij)
#     end

    FP[jfp,jfp]=1.0+FP[jfp,jfp]
end
end

"""
heqf!(F,x,pdata)

The function evaluation as per nsold rules.

The precomputed data is a big deal for this example. In particular,
the output pdata.FFA from plan_fft goes to the fixed point map
computation. Things get very slow if you do not use plan_fft.
"""
function heqf!(F,x,pdata)
HeqFix!(F,x,pdata)
#
# naked BLAS call to fix the allocation blues
#
axpby!(1.0,x,-1.0,F)
end


"""
function HeqFix!(Gfix,x,pdata)
The fixed point map. Gfix goes directly into the function and
Jacobian evaluations for the nonlinear equations formulation.

The precomputed data is a big deal for this example. In particular, 
the output pdata.FFA from plan_fft goes to the fixed point map
computation. Things get very slow if you do not use plan_fft. 
"""
function HeqFix!(Gfix,x,pdata)
global c
n=length(x)
Gfix.=c*heq_hankel(x,pdata);
@inbounds @views @simd for ig=1:n
    Gfix[ig]=1.0/(1.0 - (ig-.5)*Gfix[ig])
end
end

"""
Initialize H-equation precomputed data.
Returns (mu=mu, hseed=hseed, FFA=FFA)
Does not provide c, which is still a global
"""
function heqinit(n)
FFA=plan_fft(ones(2*n,1))
mu=.5:1:n-.5
mu=mu/n
hseed=zeros(2*n-1,1)
for is=1:2*n-1
    hseed[is]=1.0/is
end
hseed=(.5/n)*hseed
bigseed=zeros(2*n,1);
sstore=zeros(n,1)
rstore=zeros(2*n,1)
zstore=zeros(2*n,1)*(1.0 + im)
zstore2=zeros(2*n,1)*(1.0 + im)
zstore3=zeros(2*n,1)*(1.0 + im)
bigseed.=[hseed[n:2*n-1]; 0; hseed[1:n-1]]
zstore2.=conj(FFA*bigseed)
return (mu=mu, hseed=hseed, bigseed=bigseed,
       sstore=sstore, rstore=rstore, zstore=zstore, zstore2=zstore2, 
       zstore3=zstore3, FFA=FFA)
end


"""
setc(cin)

If you are varying c in a compuation, this function
lets you set it.
"""
function setc(cin)
global c
c=cin
end

"""
chandprint(x)

Print the table on page 125 (Dover edition) of Chandresekhar's book.
"""

function chandprint(x,pdata)
global c
muc=0:.05:1
mu=pdata.mu
n=length(mu)
nx=length(x)
LC=zeros(21,n)
for j=1:n
    for i=1:21
       LC[i,j]=muc[i]/(muc[i]+mu[j])
    end
end
p=c*.5/n
LC=p*LC
hout=LC*x
hout=ones(21,1)./(ones(21,1)-hout)
return [muc hout]
end
 

"""
heq_hankel!(w,b,pdata)
Multiply an nxn Hankel matrix with seed in R^(2N-1) by a vector b
FFA is what you get with plan_fft before you start computing

Overwites w with the result
"""
function heq_hankel!(w,b,pdata)
global c
n=length(b)
br=reverse(b; dims=1)
w=heq_toeplitz(br,pdata)
return w
end

"""
heq_hankel(b,pdata)
Multiply an nxn Hankel matrix with seed in R^(2N-1) by a vector b
FFA is what you get with plan_fft before you start computing
"""
function heq_hankel(b,pdata)
n=length(b)
br=reverse(b; dims=1)
w=heq_toeplitz(br,pdata)
#println(typeof(w))
return w
end

"""
heq_toeplitz(b,pdata)
Multiply an nxn Toeplitz matrix with seed in R^(2n-1) by a vector b
"""
function heq_toeplitz(b,pdata)
n=length(b);
y=pdata.rstore
@views y[1:n]=b
u=heq_cprod(y,pdata)
return u
end

"""
heq_cprod(b,pdata)
Circulant matrix-vector product with FFT
compute u = C b
"""

function heq_cprod(b,pdata)
xb=pdata.zstore
xb.=pdata.FFA\b;
w=pdata.zstore2
uz=pdata.zstore3
u=pdata.sstore
n=length(u)
#xb.=w.*xb
#uz.=pdata.FFA*xb
#u=real.(uz)
uz.=w.*xb
xb.=pdata.FFA*uz
u.=real.(xb[1:n])
return u
end


#
# end of module
#
end

