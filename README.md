# pre-and-post-processing-of-AutoStepFinder-results
Calculate Oligomer size distributions from analysing single-molecule bleaching step traces with AutoStepFinder

## Experiment:
In a TIRF microscope single protein oligomers are immobilized. Each monomer is labelled by a fluorescent dye. The protein oligomers are illuminated by a laser and videos are recorded. These videos are then analysed and intensity time traces of each fluorescent spot (i.e. of a protein oligomer) are saved. These intensity time traces show distinct bleaching steps (they look like downward stairs), each bleaching step representing the bleaching of one monomer. 

## How to use:
The matlab scripts are calles S1 to S4 and need to be used in this order.

### S1_tracesformIgortoStepfinder
**pre-processing**: Take saved single-molecule traces from Igor and save in a format that AutoStepFinder from Loeff, Kerssemakers et al can process then. 
### Use AutoStepfinder as described there
See https://github.com/LeonieVo/Loeff-Kerssemakers-et-al-AutoStepFinder and https://github.com/jacobkers/Loeff-Kerssemakers-et-al-AutoStepFinder.
### S2_HistfromStepFitResults
**post-processing**: Make histogram from AutoStepFinder results
### S3_OligomerDistribution
**post-processing**: Calculate the distribution of Oligomer sizes unsing the bleaching step histogram and the labelling effciency of the protein (degree of labelling)
### S4_Oligomers_summaryplots
**post-processing**: Compare different experiments and analyses and make overview plots
