function heqbos!(F,x)
n=length(x)
c=1.0
mu=.5:1:n-.5
mu=mu/n
h=1.0/n
cval=sqrt(1.0-c)
A=zeros(n,n)
for j=1:n
    for i=1:n
        A[i,j]=mu[j]/(mu[i]+mu[j])
    end
end
A=(c/2)*h*A
F.=(A*x)
for ig=1:n
    F[ig]=1.0/(cval + F[ig])
end
F.=x-F
end

function chandprintbos(x,mu,c)
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

