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

"""
function heqJ!(F,FP,x,pdata)

The is the Jacobian evaluation playing by nsold rules. The
precomputed data is a big deal for this one. 
"""
function heqJ!(F,FP,x,pdata)
global Gfix, c
hseed=pdata.hseed
mu=pdata.mu
precision=typeof(FP[1,1])
n=length(x)
#
# Look at the formula in the notebook and you'll see what I did here.
#
Gfix=-(c*n)*(Gfix.*Gfix.*mu)
for jfp=1:n
    FP[:,jfp].=precision.(Gfix[:,1].*hseed[jfp:jfp+n-1])
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
global Gfix, mu
ng=length(Gfix)
n=length(x)
if ng != n 
   mu=pdata.mu
   Gfix=zeros(n,1)
end
HeqFix!(F,x,pdata)
Gfix.=F
F.=x-Gfix
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
hseed=pdata.hseed
FFA=pdata.FFA
n=length(x)
Gfix.=c*heq_hankel(hseed,x,FFA);
for ig=1:n
    Gfix[ig]=1.0 - (ig-.5)*Gfix[ig]
end
Gfix.=ones(n,1) ./ Gfix;
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
return (mu=mu, hseed=hseed, FFA=FFA)
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

function chandprint(x)
global mu, c
muc=0:.05:1
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
heq_hankel(seed,b,FFA)
Multiply an nxn Hankel matrix with seed in R^(2N-1) by a vector b
FFA is what you get with plan_fft before you start computing
"""
function heq_hankel(seed,b,FFA)
n=length(b)
br=ones(n,1);
for ib=1:n
    br[ib]=b[n-ib+1]
end
w=heq_toeplitz(seed,br,FFA)
return w
end

"""
heq_toeplitz(seed,b,FFA)
Multiply an nxn Toeplitz matrix with seed in R^(2N-1) by a vector b
"""
function heq_toeplitz(seed,b,FFA)
n=length(b);
y=[b;zeros(n,1)]
w=zeros(size(b))
bigseed=zeros(2*n,1);
bigseed.=[seed[n:2*n-1]; 0; seed[1:n-1]]
u=heq_cprod(bigseed,y,FFA)
for iw=1:n
w[iw]=u[iw]
end
return w
end

"""
heq_cprod(seed,b,mode)
Circulant matrix-vector product with FFT
compute u = C b
"""

function heq_cprod(seed,b,FFA)
w=conj(FFA*seed)
xb=FFA\b;
xz=w.*xb
u=real(FFA*xz)
return u
end


#
# end of module
#
end

