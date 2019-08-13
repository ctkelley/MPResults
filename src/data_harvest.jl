"""
data_harvest(BaseDirectory)
"""
function data_harvest(BaseDirectory)
cvals=[5,99,1]
itvals=[10, 10, 30]
half="no"
levels=5
for ic=1:3
   c=cvals[ic]
   maxit=itvals[ic]
   workingdir=string(BaseDirectory,"c=",string(c))
   figtitle=string("Figure"," ",string(ic))
   cd(workingdir)
   figure(ic)
   plotknl(half, c, maxit, levels)
#   plotknl(half, c, maxit, levels; bigtitle=figtitle)
   cd("../..")
end
half="yes"
for ic=1:3
   c=cvals[ic]
   maxit=itvals[ic]
   workingdir=string(BaseDirectory,"c=",string(c),"/Float16")
   figtitle=string("Figure"," ",string(ic+3))
   cd(workingdir)
   figure(ic+3)
   plotknl(half, c, maxit, levels)
#   plotknl(half, c, maxit, levels; bigtitle=figtitle)
   cd("../../..")
end



end



