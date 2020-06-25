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
   plotnsold(half, c, maxit, levels)
#   plotnsold(half, c, maxit, levels; bigtitle=figtitle)
   cd("../..")
end
half="yes"
for ic=1:3
   c=cvals[ic]
   maxit=itvals[ic]
   workingdir=string(BaseDirectory,"c=",string(c),"/Float16")
   cd(workingdir)
   figtitle=string("Figure"," ",string(ic+3))
   plotnsold(half, c, maxit, levels)
   figure(ic+3)
   cd("../../..")
end



end



