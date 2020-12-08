"""
    nsold01(x, FS, FPS, F!, J!=diffjac!; rtol=1.e-6, atol=1.e-12, 
            maxit=20, dx=1.e-6, pdata=nothing) 

This is Version .01. Nothing with a version number having a negative
exponent field can be trusted.

Nonlinear solvers from my books in Julia. This version has no globalization,
no quasi-Newton methods, and no Newton-Krylov. The mission here is to 
duplicate the mixed precision results in my SIREV-ED submission.

# Inputs:
- x: initial iterate

- FS: Preallcoated storage for function. It is an N x 1 column vector

- FPS: preallcoated storage for Jacobian. It is an N x N matrix

- F!: function evaluation, the ! indicates that F! overwrites FS, your
    preallocated storage for the function.

- J!: Jacobian evaluation, the ! indicates that J! overwrites FPS, your
    preallocated storage for the Jacobian. If you leave this out the
    default is a finite difference Jacobian.

----------------------

# keyword arguments (kwargs):

- rtol and atol: relative and absolute error tolerances

- maxit: limit on nonlinear iterations

- dx: difference increment in finite-difference derivatives
      h=dx*norm(x)+1.e-8

- pdata: precomputed data for the function/Jacobian. 
       Things will go better if you use this rather than hide the data 
       in global variables within the module for your function/Jacobian

------------------------

# Using nsold.jl

Here are the rules as of June 6, 2019

F! is the nonlinear residual. 
J! is the Jacobian evaluation.

I like to put everything in a module so that I can use global 
(within the module) variables. 

1) You allocate storage for the function and Jacobian in advance 
   --> in the calling program <-- NOT in FS and FPS

FV=F!(FV,x) returns FV=F(x)

FP=J!(FV,FP,x) returns FP=F'(x); 
    (FV,FP, x) must be the argument list, even if FP does not need FV.
    One reason for this is that the finite-difference Jacobian
    does and that is the default in the solver.

In the future J! will also be a matrix-vector product and FPS will
be the PREALLOCATED (!!) storage for the GMRES(m) Krylov vectors.

Lemme tell ya 'bout precision. I designed this code for full precision
functions and linear algebra in any precision you want. You can declare
FPS as Float64, Float32, or Float16 and nsold will do the right thing if 
YOU do not destroy the declaration in your J! function. I'm amazed 
that this works so easily. 

If the Jacobian is reasonably well conditioned, I can see no reason
to do linear algebra in double precision

Don't try to evaluate function and Jacobian all at once because 
that will cost you a extra function evaluation every time the line
search kicks in.

2) Any precomputed data for functions, Jacobians, matrix-vector products
   may live in global variables within a module containing F! and J!. 
   Don't do that if you can avoid it. Use pdata instead.


"""
function nsold01(
    x,
    FS,
    FPS,
    F!,
    J! = diffjac!;
    rtol = 1.e-6,
    atol = 1.e-12,
    maxit = 20,
    dx = 1.e-6,
    pdata = nothing,
)

    EvalF!(FS, x, F!, pdata)
    resnorm = norm(FS)
    reshist = resnorm * ones(1,)
    tol = rtol * resnorm + atol
    itc = 0
    while resnorm > tol && itc < maxit
        #
        # FPF and FPS will now share the data for L and U, but are
        # different things. You can't say FPS=lu!(FPS) and then update
        # the Jacobian later in the nonlinear iteration.
        # 
        # Don't believe me? Try it and see.
        #
        EvalJ!(FS, FPS, x, F!, J!, dx, pdata)
        FPF = lu!(FPS)
        step = -(FPF \ FS)
        x = x + step
        EvalF!(FS, x, F!, pdata)
        resnorm = norm(FS)
        push!(reshist, resnorm)
        itc = itc + 1
    end
    return (solution = x, ithist = reshist)
end

function EvalF!(FS, x, F!, pdata)
    F!
    if pdata == nothing
        F!(FS, x)
    else
        F!(FS, x, pdata)
    end
end

function EvalJ!(FS, FPS, x, F!, J!, dx, pdata)
    if J! != diffjac!
        if pdata == nothing
            J!(FS, FPS, x)
        else
            J!(FS, FPS, x, pdata)
        end
    else
        diffjac!(FS, FPS, F!, x, dx, pdata)
    end

end

function diffjac!(FS, FPS, F!, x, dx, pdata)
    precision = typeof(FPS[1, 1])
    h = dx * norm(x, Inf) + 1.e-8
    n = length(x)
    y = ones(size(x))
    FY = ones(size(x))
    for ic = 1:n
        y .= x
        y[ic] = y[ic] + h
        if pdata == nothing
            F!(FY, y)
        else
            F!(FY, y, pdata)
        end
        for ir = 1:n
            FPS[ir, ic] = (FY[ir] - FS[ir]) / h
        end
    end

end
