# AEROptimise
A MATLAB Genetic Algorithm aerofoil optimisation tool

Although it is not the fastest option when it comes to such process, MATLAB was chosen as it is adequate when the scripts being developed are a proof of concept rather than final products that are supposed to efficiently execute and optimisation routine.

## AEROptimise Features:
1. Imports aerofoils form [Selig coordinate files](http://m-selig.ae.illinois.edu/ads/archives/coord_seligFmt.zip) as MATLAB arrays
1. Aerofoil parametrisation using the 11 and 12 parameter PARSEC methods
1. An adaption of a MATLAB [XFOIL interface](https://uk.mathworks.com/matlabcentral/fileexchange/30446-xfoil-interface) by Gus Brown that runs on Linux, macOS and Windows
    1. Bash script for Linux and macOS to kill XFOIL instances that hang while processing
    1. Windows batch file to kill XFOIL instances that hang while processing
1. Single objective (i.e. increase CL) aerofoil optimisation using absolute or percentage goals
1. Multiple objective (i.e. increase CL while decreasing CD) aerofoil optimisation using absolute or percentage goals
