# MPResults2019

This repo supports my paper __Newton's Method in Mixed Precision__. 

## What's in this repo?

### The paper and a presentation. Sooner or later I will put up.

1. A presentation on the results.
2. Some kind of link to the paper itself.

### The codes: you get all kinds of things here.

1. The codes in /src
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

This is a Julia project. It has .toml files to prove it.

1. Clone the repo and a directory called MPResults2019 will appear somewhere on your computer.
2. Put that directory in your Julia LOAD_PATH.
3. Type __using MPResults2019__ at the Julia prompt and you're ready to go.

# KNL

I'm working on putting the codes __and examples__ from my nonlinear solver books together as a Julia package and a book. This will take some time. __knlv01.jl__ is a simple Newton code (no globalization, no Krylov solver, ...) but it does let you do linear solves in your choice of precision, which is the point of this paper. 

At some point (after Armijo, GMRES, and pseudo-transient continuation get in there) I will put this up as a package with several examples. Until then, I will update knl as I use it for my own research. Krylov coming soon.
