# Integrated Precision Matlab Toolbox

Thomas A. Lampert, ICube, University of Strasbourg

This work was carried out as part of the FOSTER project, which is funded by the French Research Agency (Contract 
ANR Cosinus, ANR-10-COSI-012-03-FOSTER, 2011—2014): http://foster.univ-nc.nc/

## README


This toolbox accompanies the paper:

T. Lampert and P. Gancarski, 'The Bane of Skew: Uncertain Ranks and Unrepresentative Precision'. Machine Learning 97 (1-2): 5—32, 2014.

It contains implementations of the functions described within the paper related to Precision-Recall and integrated 
Precision-Recall curves. It may also be used to recreate the paper's figures to gain a better understanding of the 
method.

To use the toolbox's functions, simply add the toolbox directory to Matlab's path. Within the header of each 
function may be found a short description of its purpose and in which section of the paper its mathematical 
derivation can be found.

To recreate the figures, set Matlab's current working directory to '/figures' and execute any one of the scripts 
(figure2, figure3, figure4, figure5, figure6ab, figure6cd, figure7a & b, figure8a & b, or figure9). To recreate 
figures 7b and 8b, the ground truths from the STARE dataset need to be downloaded from 

http://www.parl.clemson.edu/~ahoover/stare/probing/index.html

and placed into the %toolboxroot%/detector_responses/STARE/GTs directory. These figures use the detections included
(located in %toolboxroot%/detector_responses/STARE/Results) which were calculated using the MLVessel package, 
available from

http://sourceforge.net/apps/mediawiki/retinal/index.php?title=Software

for more details see the readme located in the results directory.

The third directory, 'detector_responses', contains data that is used to recreate the P-R curves in the remaining
figures. These images are the outputs of a Gaussian linear detector ('gauss_response.tif') and a centre-surround 
type detector ('cs_response.tif'), the ground truth associated with these is contained within the file 'gt.tif'. 
For more information regarding the vision problem that results in these images please refer to:

T. Lampert, A. Stumpf, P. Gancarski, 'An Empirical Study of Annotator Agreement, Ground Truth Estimation, and Algorithm Evaluation'. (submitted).


The names of the functions within the toolbox directory should be pretty self-evident, the following abbreviations
are used:

    pr   - precision recall functions
    ipr  - integrated precision recall functions
    tiPR - temporally integrated precision recall functions
    wiPR - weighted integrated precision recall functions

Each of the following functions contain integral and discrete versions of the equations included (the default is the
integral version, which is more accurate but slower, there is a boolean switch to change which is used):

    /toolbox/ipr_point.m
    /toolbox/ipr_interpolate.m
    /toolbox/ipr_unattainable.m
    /toolbox/tipr_point.m
    /toolbox/tipr_interpolate.m
    /toolbox/tipr_unattainable.m
    /toolbox/tipr_random_classifier.m
    /toolbox/wipr_point.m
    /toolbox/wipr_interpolate.m
    /toolbox/wipr_unattainable.m
    /toolbox/wipr_random_classifier.m
    /figures/support_functions/landgrebe_ipr_point.m

all of the functions that recreate figures have an boolean option to turn integration off, which speeds things up a bit.

[![Analytics](https://ga-beacon.appspot.com/UA-112264682-2/welcome-page?pixel)](https://github.com/igrigorik/ga-beacon)
