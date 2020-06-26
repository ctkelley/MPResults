"""
data_harvest(BaseDirectory; ptable=false)
"""
function data_harvest(BaseDirectory; ptable = false)
    cvals = [5, 99, 1]
    itvals = [10, 10, 30]
    half = "no"
    levels = 5
    for ic = 1:3
        c = cvals[ic]
        maxit = itvals[ic]
        workingdir = string(BaseDirectory, "c=", string(c))
        if ptable == false
            figtitle = string("Figure", " ", string(ic))
            figure(ic)
        end
        cd(workingdir)
        plotnsold(half, c, maxit, levels; table = ptable)
        #   plotnsold(half, c, maxit, levels; bigtitle=figtitle)
        cd("../..")
    end
    half = "yes"
    for ic = 1:3
        c = cvals[ic]
        maxit = itvals[ic]
        workingdir = string(BaseDirectory, "c=", string(c), "/Float16")
        cd(workingdir)
        if ptable == false
            figure(ic + 3)
            figtitle = string("Figure", " ", string(ic + 3))
        end
        plotnsold(half, c, maxit, levels; table = ptable)
        #   plotnsold(half, c, maxit, levels; bigtitle=figtitle)
        cd("../../..")
    end



end
