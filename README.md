# MPResults

This is v1.0

This repo supports my paper 

C. T. Kelley,
__Newton's Method in Mixed Precision__,
2021, To appear in __SIAM Review__

__This version will make the plots/tables in the paper/notebook.__

This uses the solvers and test problems from my new [SIAMFANLEquations.jl](https://github.com/ctkelley/SIAMFANLEquations.jl) package.

## Readme Contents

[Files](#What's-in-this-repo)

[Usage](#How-to-use-this-mess)

[Solver](#NSOLD)

[Notebook Problems?](#Notebook-Problems)

[Research Support](#Support)


## What's in this repo

1. The codes in /src
   You need these packages: 
   1. PyPlot
   2. LinearAlgebra
   3. __SIAMFANLEquations__
   4. Printf
   5. FFTW
   6. AbstractFFTS
2. The data I used to make the plots in /Data_From_Paper
   1. The half-precision data takes a very long time to generate (days to weeks)
   2. I show you how to make an abridged version of the plots in the notebook ...
3. A juypter notebook **MPResults.ipynb** explaining how it all works
   1. If the notebook fails to render, do not bother me. Instead, look at the sad tale of woe on
       https://github.com/jupyter/notebook/issues/3555
       1. The pdf is a better job than github's render anyhow. You can look at it.
   2. It's even better to clone the repo and get to the notebook from your own computer anyhow.
   3. __newtonmp.html__ is the bib for the notebook. __Do not touch it__.
4. A pdf file of the notebook.
5. Viewgraphs from a talk I gave at Hong Kong Polytechnic on this.

## How to use this mess

This is a Julia application. It has .toml files to prove it.

Look at https://julialang.github.io/Pkg.jl/v1/glossary/# to see the difference between an application, 
a project, and a package.

0. Have a github accout and know how to use it.

1. Clone the repo into your choice of directory. My favorite way to do this is to cd to that directiory and issue this terminal command

git clone https://github.com/ctkelley/MPResults

2. Put MPResults in your Julia LOAD_PATH with the command (issued from the REPL)

   __push!(LOAD_PATH,"/Users/yourid/whereyouputit/MPResults")__
   
   You must use the absolute pathname (ie starting with /Users for Mac) for this.
3. Type __using MPResults__ at the Julia prompt and you're ready to go. Unless ...
     1. If you get complaints about missing packages, install those packages. Then try again.
     2. Alternatively, for those of you who are comfortable using pkg...
         1. cd to the MPResults directory. Fire up pkg (the package manager) by typing __]__ at the julia prompt. 
         
         2. Then
     
        (v1.2) pkg> __activate .__
        
                Activating environment at `~/Julia/MPResults/Project.toml`

        MPResults) pkg> __instantiate__<br>
        MPResults) pkg> __update__
       
          3. Get out of pkg by typing a backspace. 
          
          Julia prints out the story of package installation. The instantiate command should install your missing packages automatically. The update part is to make sure that you're using the latest stuff. I will try to keep this updated, but I could be dead when you read this.
        
   4. Fire up IJulia by 
      1. Typing ```notebook``` at the REPL Prompt
      2. Navigating to the MPResults directory
      3. Clicking on MPResults.ipynb
      4. Do __run all__ to make sure the LaTeX macros and the dependencies are in there. It is really important to run the first cell in the notebook. That is an invisible markdown cell with the LaTeX macros. The second cell is a code cell that organizes the dependencies and makes sure you're starting from the correct directory.
 

        
       

## NSOL

__nsol.jl__ is from my new book/package/notebook project. 

# Solving Nonlinear Equations with Iterative Methods: <br> Solvers and Examples in Julia

This book will be a sequel to 

(Kel03) C. T. Kelley, [***Solving Nonlinear Equations with Newton's Method***](https://my.siam.org/Store/Product/viewproduct/?ProductId=841) , Fundamentals of Algorithms 1, SIAM 2003.

The components are
 -  A book now under contract to be published by SIAM in 2022
 -  A Julia package: [SIAMFANLEquations.jl](https://github.com/ctkelley/SIAMFANLEquations.jl)
 - [A collecton of IJulia notebooks:](https://github.com/ctkelley/NotebookSIAMFANL/releases/tag/v0.2.3)


## Notebook Problems
 
It is very important that PyPlot and IJulia use the same version of conda. If the notebook is complaining about the kernel, that is likely the issue. You have a good chance of fixing this with the __update__ command within pkg (see detailsbelow). If you did the update when you installed this application and are still having problems. Try typing __update IJulia__ and __build IJulia__ from pkg. 


__How to update all packages__: If you are running anything other than Julia 1.5. Your packages may be out of sync with the application. To fix this
       1. Do a package update from the REPL
       2. From the REPL in the MPResults directory. 
          a. Type ] to get into the package manager
          b. type  ```activate .``` (the . is important) at the package prompt
          c. type ```update``` at the package prompt
          d. hit backspace to exit the package manager   
       3. Doing this will update the .toml files for the application   

If that fails ...

The worst case, which has happened to me more than once, is that you'll have to 

   1. Move .julia/config to a safe place.
      1. Your startup.jl lives in config. Don't lose it.
        
   2. Delete or move .julia
   
   3. Run Julia (which will create a new .julia in your home directory)
      1. Put your config diectory back in there. 
      
  4. Reinstall ALL YOUR PACKAGES! That is a real pain, but has never failed to fix the problem for me.    
      
   
        
   
        

## Support

This project was partially supported by
1. Army Research Office grant W911NF-16-1-0504 and
2. National Science Foundation Grants
   1. OAC-1740309
   2. DMS-1745654
   3. DMS-1906446
3. Department of Energy grant DE-NA003967
   
Any opinions, findings, and conclusions or
recommendations expressed in this material are those of the author and
do not necessarily reflect the views of the National
Science Foundation, the Department of Energy,
or the Army Research Office.
