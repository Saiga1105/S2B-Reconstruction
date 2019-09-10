# Scan-to-BIM Segmentation repository

This toolbox includes functions for the segmetation of point clouds and meshes.
It contains the region growing methods based on parallel processing in matlab to segment several millions of points (40k points/s) 
ALso, the training and testing of Conditional Random Fields is introduced based on UGM by Schmidt to reduce oversegentation.
The sample files contain some example wall segments.

The toolbox was developped for the reconstruction BIM geometry from meshes.
Therefore, it can be used together with other toolboxes (see Related Toolboxes Section)

### Contribute
There are several large files in this repository (matlab .dll's and sample files)
Use github's Large File System (lfs) to push changes to the origin.

make sure the .dll files are tracked after commiting
	* git lfs track '*.dll'
	* git lfs track '*.mat'

### License 
If you use this software in a publication, please cite the work using the following information:

Bassier M., Vergauwen M. (2019) Clustering of Wall Geometry from Unstructured Point Clouds Using Conditional Random Fields. 
Remote Sensing, 11(13), 1586; https://doi.org/10.3390/rs11131586

Courtesy of the **KU Leuven research group in Geomatics**, TC BOUW, Department of Civil Engineering, KU Leuven, Belgium. https://iiw.kuleuven.be/onderzoek/geomatics

### Dependencies
* M. Schmidt. UGM: A Matlab toolbox for probabilistic undirected graphical models. http://www.cs.ubc.ca/~schmidtm/Software/UGM.html, 2007.
* MATLAB Runtime version 9.4 (R2018a). You can download it at http://www.mathworks.com/products/compiler/mcr/index.html
* MATLAB Statistics and Machine Learning Toolbox
* MATLAB Computer Vision Toolbox


### Related Toolboxes
The grashopper plug in consumes following Open Source Toolboxes from the same author.

S2B-Segmentation  
S2B-Classification  
S2B-Clustering  
S2B-Reconstruction  

