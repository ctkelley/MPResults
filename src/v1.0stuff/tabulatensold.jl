"""
tabulatensold(half="no",c=.5,maxit=10,level=5; bigtitle="")

Makes the tabulates for the SIAM Review paper.

Makes convergence rate tables for Float16 computations.

Newton's Method in Mixed-Precision.

"""
function tabulatensold(half = "no", c = 0.5, maxit = 10, level = 5; bigtitle = "")
    Fdata = zeros(4, level, maxit + 1)
    dout = zeros(maxit + 1, level)
    fillFdata!(Fdata, level, half)
    #
    # Get the data for the tables
    #
    ipmax = 4
    if half == "yes"
        ipmax = 2
    end
    headers = ["n", "1024", "2048", "4096", "8192", "16384"]
    formats = "%d & %9.5e & %9.5e & %9.5e & %9.5e & %9.5e"
    Rates = zeros(maxit, 6)
    Rates[:, 2:6] = transpose(Fdata[1, 1:level, 2:maxit+1] ./ Fdata[1, 1:level, 1:maxit])
    Rates[:, 1] = 1:maxit
    fprintTeX(headers, formats, Rates)
    return Rates
end

function fillFdata!(Fdata, level, half)
    #
    # Read the data files and get organized.
    #
    loadme(fmt::String) = @eval @load($fmt)
    for ir = 1:level
        gridlev = 512 * (2^ir)
        mixedpfile = string("paper", string(gridlev), ".jld2")
#        mixedpfile = string("paper", string(gridlev), ".jld")
        loadme(mixedpfile)
        if half == "no"
            Fdata[1, ir, :] .= fout64.exactout.ithist
            Fdata[2, ir, :] .= fout64.fdout.ithist
            Fdata[3, ir, :] .= fout32.exactout.ithist
            Fdata[4, ir, :] .= fout32.fdout.ithist
        else
            Fdata[1, ir, :] .= fout16.exactout.ithist
            Fdata[2, ir, :] .= fout16.fdout.ithist
        end
    end
end
