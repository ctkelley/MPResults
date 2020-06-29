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

export heqf!
export heqJ!
export setc!
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
function heqJ!(F, FP, x, pdata)
    precision = typeof(FP[1, 1])
    pseed = pdata.pseed
    mu = pdata.mu
    n = length(x)
    #
    # Look at the formula in the notebook and you'll see what I did here.
    #
    pmu = pdata.pmu
    Gfix = pdata.gtmp
    @views Gfix .= precision.(x - F)
    @views Gfix .= -(Gfix .* Gfix .* pmu)
    @views @inbounds for jfp = 1:n
        FP[:, jfp] .= Gfix[:, 1] .* pseed[jfp:jfp+n-1]
        FP[jfp, jfp] = 1.0 + FP[jfp, jfp]
    end
end

"""
heqf!(F,x,pdata)

The function evaluation as per nsold rules.

The precomputed data is a big deal for this example. In particular,
the output pdata.FFB from plan_fft! goes to the fixed point map
computation. Things get very slow if you do not use plan_fft or plan_fft!
"""
function heqf!(F, x, pdata)
    HeqFix!(F, x, pdata)
    #
    # naked BLAS call to fix the allocation blues
    #
    # Using any variation of F.=x-F really hurts
    #
    axpby!(1.0, x, -1.0, F)
end


"""
function HeqFix!(Gfix,x,pdata)
The fixed point map. Gfix goes directly into the function and
Jacobian evaluations for the nonlinear equations formulation.

The precomputed data is a big deal for this example. In particular, 
the output pdata.FFA from plan_fft goes to the fixed point map
computation. Things get very slow if you do not use plan_fft. 
"""
function HeqFix!(Gfix, x, pdata)
    n = length(x)
    Gfix .= x
    heq_hankel!(Gfix, pdata)
    Gfix .*= pdata.pmu
    Gfix .= 1.0 ./ (1.0 .- Gfix)
end

"""
Initialize H-equation precomputed data.
Returns (mu=mu, hseed=hseed, FFA=FFA)
"""
function heqinit(x0, n, c, TJ)
    T = typeof(x0)
    n = length(x0)
    cval=ones(1,)
    cval[1]=c
    if T <: Vector
        vsize = (n,)
        bsize = (2 * n,)
        ssize = (2 * n - 1,)
    else
        error("please dimension your stuff as vectors, ie (n,) not (n,1)")
    end
    FFA = plan_fft(ones(bsize))
    mu = collect(0.5:1:n-0.5)
    pmu = TJ.(mu * c)
    mu = mu / n
    hseed = zeros(ssize)
    for is = 1:2*n-1
        hseed[is] = 1.0 / is
    end
    hseed = (0.5 / n) * hseed
    pseed = TJ.(hseed)
    gtmp = zeros(TJ, vsize)
    rstore = zeros(bsize)
    zstore = zeros(bsize) * (1.0 + im)
    hankel = zeros(bsize) * (1.0 + im)
    FFB = plan_fft!(zstore)
    bigseed = zeros(bsize)
    @views bigseed .= [hseed[n:2*n-1]; 0; hseed[1:n-1]]
    @views hankel .= conj(FFA * bigseed)
    return (
        cval=cval,
        mu = mu,
        hseed = hseed,
        pseed = pseed,
        gtmp = gtmp,
        pmu = pmu,
        rstore = rstore,
        zstore = zstore,
        hankel = hankel,
        FFB = FFB,
    )
end


"""
setc(cin)

If you are varying c in a computation, this function
lets you set it.
"""
function setc!(pdata, cin)
    c=pdata.cval[1]
    cfix=cin/c
    pdata.pmu.*=cfix
    pdata.cval[1]=cin
end

"""
chandprint(x)

Print the table on page 125 (Dover edition) of Chandresekhar's book.
"""

function chandprint(x, pdata)
    c=pdata.cval[1]
    muc = collect(0:0.05:1)
    mu = pdata.mu
    n = length(mu)
    nx = length(x)
    LC = zeros(21, n)
    for j = 1:n
        for i = 1:21
            LC[i, j] = muc[i] / (muc[i] + mu[j])
        end
    end
    p = c * 0.5 / n
    LC = p * LC
    hout = LC * x
    onex = ones(size(muc))
    hout = onex ./ (onex - hout)
    return [muc hout]
end


"""
heq_hankel(b,pdata)
Multiply an nxn Hankel matrix with seed in R^(2N-1) by a vector b
FFA is what you get with plan_fft before you start computing
"""
function heq_hankel(b, pdata)
    n = length(b)
    br = reverse(b; dims = 1)
    heq_toeplitz!(br, pdata)
    return br
end

"""
heq_hankel!(b,pdata)
Multiply an nxn Hankel matrix with seed in R^(2N-1) by a vector b
FFA is what you get with plan_fft before you start computing
"""
function heq_hankel!(b, pdata)
    reverse!(b)
    heq_toeplitz!(b, pdata)
end


"""
heq_toeplitz!(b,pdata)
Multiply an nxn Toeplitz matrix with seed in R^(2n-1) by a vector b
"""
function heq_toeplitz!(b, pdata)
    n = length(b)
    y = pdata.rstore
    y .*= 0.0
    @views y[1:n] = b
    heq_cprod!(y, pdata)
    @views b .= y[1:n]
end

"""
heq_cprod!(b,pdata)
Circulant matrix-vector product with FFT
compute u = C b

Using in-place FFT
"""

function heq_cprod!(b, pdata)
    xb = pdata.zstore
    xb .*= 0.0
    xb .+= b
    pdata.FFB \ xb
    hankel = pdata.hankel
    xb .*= hankel
    pdata.FFB * xb
    b .= real.(xb)
end


#
# end of module
#
end
