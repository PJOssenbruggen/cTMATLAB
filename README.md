# cT_MATLAB
cTMATLAB is a respository of MATLAB code in CarTools.

The cT_MATLAB folder contains the functions necessary to generate the tables and graphs described in the paper, "A Case for Feedback Control in Preventing Delay." See "manuscript.pdf".

The paper satisfies ASCE requirements that SI units be used. However, all cT_MATLAB functions are written in the British-American System of Units and then converted. Say for example, a traffic density function exists with input variables of vehicle count and length. Thus, the user will specify a numbers for the count and road length where the length is given in "miles," respectively. The output will be given in units of "vehicles per mile." To satisfy the ASCE, the output is obtained and then converted to "vehicles per km."  Both units will be displayed. Graphs are displayed usin SI units only. 

A person interested in using cT_MATLAB should follow the following procedure: (1) Download all files marked with the extension, ".m" and place them in a folder somewhere on your computer. (2) Upload all ".m" files into MATLAB. (3) Find the function named, "cT_main.m". Make no changes. (4) Execute the "cT_main.m" function by going to the "Editor" and clicking "Run". Ten figures and several tables will appear in the "Command Window." (5) Check the figures to be sure that they identical to the figures shown in "manuscript.pdf". If so, then feel to use it anyway you wish.

If you have questions or problems, send me an email at "pjo@unh.edu."
