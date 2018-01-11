# AEROptimise
A MATLAB Genetic Algorithm aerofoil optimisation tool

Although it is not the fastest option when it comes to such process, MATLAB was chosen as it is adequate when the scripts being developed are a proof of concept rather than final products that are supposed to efficiently execute and optimisation routine.

## AEROptimise Features:
1. Imports aerofoils form [Selig coordinate files](http://m-selig.ae.illinois.edu/ads/archives/coord_seligFmt.zip) as MATLAB arrays
1. Aerofoil parametrisation using the 11 and 12 parameter PARSEC methods
    1. PARSEC11 parametrises the whole aerofoil as one curve
    1. PARSEC12 parametrises the upper and lower surfaces of the aerofoil separately
1. Aerofoil plotting of original aerofoil, its parametrisation and displaying the obtained parameters
1. An adaption of a MATLAB [XFOIL interface](https://uk.mathworks.com/matlabcentral/fileexchange/30446-xfoil-interface) by Gus Brown that runs on Linux, macOS and Windows
    1. Bash script for Linux and macOS to kill XFOIL instances that hang while processing
    1. Windows batch file to kill XFOIL instances that hang while processing
1.Aerofoil optimisation using genetic algorithm
    1. Absolute (i.e. CL=1.2) or percentage goals (i.e 1.2*Original CL)
    1. Single objective (i.e increase CL) or multiple objective (i.e. increase CL while descreasing CD)
    1. Single or multiple angles of attack
1. a .txt file optimisation log that includes:
    1. PARSEC parameters of each generation
    1. measured performance of each generation
    1. RMS error between measured performance and objective
    
# Usage
1. Download `xfoil` executable that matches your system from <http://web.mit.edu/drela/Public/web/xfoil/>
    1. For macOS download 'Xfoil.app' and follow this short guide
1. run `setup.m` 
1. 
