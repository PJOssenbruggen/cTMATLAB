# cT_MATLAB
cTMATLAB is a respository of MATLAB code, data and figures.

The cT_MATLAB folder contains the functions necessary to generate the tables and graphs described in the paper, "A Case for Feedback Control in Preventing Delay." See "manuscript.pdf".

The "Bottleneck folder" contains the code that was used to generate the information contained in the "A Case Study: Managing Bottleneck Delay and Breakdown." A person interested in this work should peruse the material in the "Bottleneck folder" first. Much more care was taken in editing and organizing the material.

If you have questions or problems, send me an email at "pjo@unh.edu."

A person interested in using cT_MATLAB or Bottleneck is urged to do the following: 
1. Download all files marked with the extension, ".m" and place them in a folder somewhere on your computer. 
2. Upload all ".m" files into MATLAB. 
3. Find the function named, "Bottleneck1.m". Make no changes. 
4. Execute the "Bottleneck1.m" function by going to the "Editor" and clicking "Run". Execute "Bottleneck2.m"  and "Bottleneck3.m" the same way,
Eight figures and several tables will appear in the "Command Window." 
5. Check the figures to be sure that they identical to the figures shown in "manuscript.pdf" file that accompanies this paper. It will be available soon. 

Feel free to use the material any way that you wish. I would appreciate an email stating how you use it.

These papers satisfy ASCE requirements that SI units be used. However, all cT_MATLAB functions are written in the British-American System of Units and then converted. Say for example, a traffic density function exists with input variables of vehicle count and length. Thus, the user will specify a numbers for the count and road length where the length is given in "miles," respectively. The output will be given in units of "vehicles per mile." To satisfy the ASCE, the output is obtained and then converted to "vehicles per km."  Both units will be displayed. Graphs are displayed usin SI units only. 
