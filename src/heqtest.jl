"""
heqtest(n=100, c=.5, printh="yes"; jprecision=Float64, jmaxit=10)

Generates the examples for the SIREV paper.
"""
function heqtest(n = 100, c = 0.5, printh = "yes"; 
         jprecision = Float64, jmaxit = 10, hsham=1)
    FS = ones(n)
    x0 = ones(n)
    hdata = heqinit(x0, c);
    FPS = ones(jprecision, n, n)
    bargs=(atol = 1.e-20, rtol = 1.e-20, sham = hsham, resdec = .1, dx=1.e-6,
        pdata = hdata, maxit = jmaxit, stagnationok=true, 
        armmax=0, printerr=false)
    nsoloutfd = nsol( heqf!, x0, FS, FPS; bargs...)
    nsoloutex = nsol( heqf!, x0, FS, FPS, heqJ!; bargs...)
    if printh == "yes"
        sol = nsoloutex.solution
        cpout = chandprint(sol, hdata)
        for i = 1:21
            @printf("%1.2e      %1.5e \n", cpout[i, 1], cpout[i, 2])
        end
        @printf("\n \n \n")
        println(nsoloutex.history)
    end
    return (exactout = nsoloutex, fdout = nsoloutfd)
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

function htime(n)
(x0, FS, FPS, FPS32, hdata) = hset(n);
println("analytic, Newton, Float64");
@time htest(x0, FS, FPS, hdata; analytic=true, hsham=1);
println("analytic, Newton, Float32");
@time htest(x0, FS, FPS32, hdata; analytic=true, hsham=1)
end

function htest(x0, FS, FPS, hdata; analytic=false, hsham=5)
    n=length(FS)
    #
    # I've preallocaed x0, FS, and FPS. But they may have been changed by previous runs.
    # The cost of resetting their entries to 1.0 is insignificant. 
    #
    FS.=1.0
    FPS.=1.0
    bargs=(atol = 1.e-10, rtol = 1.e-10, sham = hsham, resdec = .1, pdata=hdata)
    if analytic
        nout=nsol( heqf!, x0, FS, FPS, heqJ!; bargs...)
    else
        nout=nsol( heqf!, x0, FS, FPS; bargs...)
    end
    return nout
end

function hset(n)
FS=ones(n,); 
FPS=ones(n,n); 
FPS32=ones(Float32,n,n); 
x0=ones(n,); 
c=.5; 
hdata = heqinit(x0, c);
return(x0, FS, FPS, FPS32, hdata)
end
