# hand-drawn-circuit-recognition
MATLAB scripts for training, detecting and classifying electric components



These scripts require the vlfeat package. Download the latest vlfeat from their website.
Steps for the setup.

1) Extract vlfeat tar file. Change MATLAB's directory to vlfeat/toolbox and type run('vl_setup.m') in
   MATLAB command window.
2) Now change the MATLAB's directory back to the folder of this project.
3) Run sketchrec M-file with the path to the image as an argument you want to detect. Sample Usage sketchrec('../TestCircuit/circuit1.jpg').


To train SVM, run loaddbimage.
