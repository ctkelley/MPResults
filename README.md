# MPResults2019

This repo supports my paper __Newton's Method in Mixed Precision__. 

## What's in this repo?

1. A presentation on the results. __MPResults2019.pdf__

### Sooner or later I'll finish the paper and put up


2. Some kind of link to the paper itself.

### The codes: you get all kinds of things here.

1. The codes in /src
   You need these packages: 
   1. PyPlot
   2. LinearAlgebra
   3. JLD2
   4. Printf
2. The data I used to make the plots in /Data_From_Paper
   1. The half-precision data takes a very long time to generate (weeks)
   2. I show you how to make an abridged version of the plots in the notebook ...
3. A juypter notebook explaining how it all works
   1. If the notebook fails to render, do not bother me. Instead, look at the sad tale of woe on
       https://github.com/jupyter/notebook/issues/3555
   2. It's better to clone the repo and get to the notebook from your own computer anyhow.
   3. __newtonmp.html__ is the bib for the notebook. Do not touch it.
4. A pdf file of the notebook.
5. The LaTeX and BiBTex files for this in /BiB_and_LaTeX

## How to use this mess

This is a Julia application. It has .toml files to prove it.

Look at https://julialang.github.io/Pkg.jl/v1/glossary/# to see the difference between an application, 
a project, and a package.

1. Clone the repo from into choice of directory. My favorite way to do this is to cd to that directiory and issue this terminal command

git clone https://github.com/ctkelley/MPResults2019

2. Put MPResults2019 in your Julia LOAD_PATH with the command (issued from the REPL)

   __push!(LOAD_PATH,"/Users/yourid/whereyouputit/MPResults2019")__
   
   You must use the absolute pathname (ie starting with /Users for Mac) for this.
3. Type __using MPResults2019__ at the Julia prompt and you're ready to go. Unless ...
     1. If you get complaints about missing packages, install those packages. Then try again.
     2. Alternatively, for those of you who are comfortable using pkg...
         1. cd to the MPResults2019 directory. Fire up pkg (the package manager) by typing __]__ at the julia prompt. 
         
         2. Then
     
        (v1.2) pkg> __activate .__
        
                Activating environment at `~/Julia/MPResults2019/Project.toml`

        MPResults2019) pkg> __instantiate__
        
                Julia prints out the story of package installation.
        
       The instantiate command should install your missing packages automatically. 
       
          3. Get out of pkg by typing a backspace. 


# KNL

I'm working on putting the codes __and examples__ from my nonlinear solver books together as a Julia package and a book. This will take some time. __knlv01.jl__ is a simple Newton code (no globalization, no Krylov solver, ...) but it does let you do linear solves in your choice of precision, which is the point of this paper. 

At some point (after Armijo, GMRES, and pseudo-transient continuation get in there) I will put this up as a package with several examples. Until then, I will update knl as I use it for my own research. Krylov coming soon.


# Support

This project was partially supported by
1. Army Research Office grant W911NF-16-1-0504 and
2. National Science Foundation Grants
   1. OAC-1740309
   2. DMS-1745654
   3. DMS-1906446
