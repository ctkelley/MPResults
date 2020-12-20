"""
TableData(c; half=false, level=5)

Makes LaTeX tables for the paper
"""
function TableData()
cvals=[.5, .99, 1.0]
for ic=1:3
    MakeTable(cvals(ic))
end
end


function MakeTable(c,tex=true)
fname=Fname(c,Float16)
c==1 ? (maxit=30) : (maxit=10)
DataC=zeros(maxit+1,5,2)
tcap=string("Half Precision Computed Convergence Rates: c=",string(c))
readmpdata(fname,DataC)
for it=1:2
for iz=1:5
DataC[:,iz,it] = DataC[:,iz,it]./DataC[1,iz,it];
end
end
qresid=DataC[:,:,1]
qrate=qresid[2:maxit+1,:]./qresid[1:maxit,:]
itnum=collect(Int,1:maxit);
Rates=[itnum qrate]
if tex
headers = ["n", "1024", "2048", "4096", "8192", "16384"]
formats = "%d & %9.5e & %9.5e & %9.5e & %9.5e & %9.5e"
fprintTeX(headers, formats, Rates)
else
headers = ["1024", "2048", "4096", "8192", "16384"]
printhist(qrate,headers)
end
end


"""
fprintTeX(headers,formats,data)

Print a LaTeX table from a Julia array.

Inputs:
headers: the titles for the columns
          example: headers=["foo", "bar"]
formats: c-style formatting for the columns.
          fprintTeX will add the carriage returns for you.
          example: formats="%d & %7.2e";
"""
function fprintTeX(headers, formats, data)
    (mr, mc) = size(data)
    @printf("\\begin{tabular}{")
    for i = 1:mc
        @printf("l")
    end
    @printf("} \n")
    for i = 1:mc-1
        @printf("%9s &", headers[i])
    end
    @printf("%9s \\\\ \n" , headers[mc])
    @printf("\\hline \n")
    #
    # I am not sure why @printf needs this, but it does.
    # See https://github.com/JuliaLang/julia/issues/4248
    #
    printf(fmt::String, args...) = @eval @printf($fmt, $(args...))
    #
    bigform = string(formats, "   \\\\ \n")
    for i = 1:mr
        printf(bigform, data[i, :]...)
    end
    @printf("\\hline \n")
    @printf("\\end{tabular} \n")
end


"""
printhist(tablein,headers;TeX=false,figures=5)

You are not supposed to look at this code. It is mostly repulsive
bookkeeping.

Inputs:
tablein: columns of equal length with the data
         Pad the short ones with NaNs. My codes which all this
         do that. The formatting turns the NaNs into spaces of
         the correct length.
headers: the titles for the columns
         example: headers=["foo", "bar"]
         Do not add the header for the iteration counter. I do that.
TeX:     Format the tabel in LaTeX or not?
figures: The printf format will be (figures+7).figures e
         So if figures = 5 the data will be formatted in %12e5.
         This makes everything line up.


Compare iteration histories from SIAMFANLEquations family of solvers.
This is usually called by something else.
Nothing to see here. Move along.
"""
function printhist(tablein, headers; TeX = false, figures = 5)
    ntab = length(tablein[1, :])
    bighead = Array{String,2}(undef, 1, ntab + 1)
    bighead[1] = "n"
    for ih = 2:ntab+1
        bighead[ih] = headers[ih-1]
    end
    if ntab > 5
        error("Too many columns for the table. Use fewer.")
    end
    fmtout = buildformat(ntab, TeX, figures)
    tabfmt = fmtout.format
    nanspace = fmtout.nanspace
    headerfmt = fmtout.headerfmt
    printf(fmt::String, args...) = @eval @printf($fmt, $(args...))
    sprintf(fmt::String, args...) = @eval @sprintf($fmt, $(args...))
    itmax = length(tablein[:, 1])
    itc = 0:itmax-1
    if TeX
        @printf("\\begin{tabular}{")
        for i = 1:ntab+1
            @printf("l")
        end
        @printf("} \n")
        printf(headerfmt, bighead...)
    else
        printf(headerfmt, bighead...)
    end
    for it = 1:itmax
        st = sprintf(tabfmt, it, tablein[it, :]...)
        snan = findfirst(isequal('N'), st)
        lt = length(st)
        while typeof(snan) != Nothing
            st = string(st[1:snan-1], nanspace, st[snan+3:lt])
            snan = findfirst(isequal('N'), st)
        end
        printf("%s", st)
    end
    if TeX
        @printf("\\hline \n")
        @printf("\\end{tabular} \n")
    end
end

function buildformat(ntab, TeX, figures)
    format = "%2d "
    nanspace = "   "
    fwide = figures + 7
    fm1 = string(fwide)
    fm2 = string(figures)
    basefmt = string(" %", fm1, ".", fm2, "e ")
    hfmt = string(" %", fm1, "s")
    headerfmt = " %s"
    if TeX
        for i = 1:ntab
            format = string(format, "&", basefmt)
            headerfmt = string(headerfmt, "&", hfmt)
        end
        format = string(format, " \\\\ \n")
        headerfmt = string(headerfmt, " \\\\ \\hline \n")
    else
        for i = 1:ntab
            format = string(format, basefmt)
            headerfmt = string(headerfmt, hfmt)
        end
        format = string(format, " \n")
        headerfmt = string(headerfmt, " \n \n")
    end
    return (format = format, nanspace = nanspace, headerfmt = headerfmt)
end
