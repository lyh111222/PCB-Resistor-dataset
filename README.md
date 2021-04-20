# PCB-Resistor-dataset
In order to evaluate the defect level of PCB SMD(Surface Mounted Devices) Resistor images.

# Instructions
The existing tools for capturing images and image segmentation process is shown in the Figure 1. Our method mainly aims to segment the resistance from the local area of the PCB image, but there is no public dataset suitable for testing. Therefore,we establish a new labeled dataset and benchmark containing grayscale image of SMD Resistor. These images are areas with resistance captured from the same type of PCB.
We use them to capture more than 60 PCB images of the same type in a continuous acquisition manner, and the fixed resolution is 2592x1944, the exposure value is 133875, and the gain is 3.Then, template matching method in is used to cut out the rectangular area of the PCB containing the SMD Resistors, thus obtaining 400 resistor images. Finally, we artificially make the ground truth image corresponding to each image.
# Folder
The image folder contains 400 PCB resistance images.  
GT folder is the corresponding ground truth image of PCB resistor
## 

#### code

Run 'demo' - It will remove the texture in folder named A.

#### result

The  results are displayed in a folder named Resultour.
 
## 

#### code

Run 'testdemo' - it will use the template in folder named mb to match all the images in folder named img.

#### result

The matching results are displayed in a folder named Resultour.
​(There are already results in a folder named Resultour0)

###image
The image named "template_process.jpg" shows the process of extracting the prior shape.
The image named "segment_process.jpg" shows the evolution of the curve in this method.
The image named "PCB.jpg" is a partial image of the PCB .
![template_process](template_process.jpg)
![segment_process](https://github.com/lyh111222/PCB-Resistor-dataset/blob/main/Template%20matching/segment_process.jpg)
![PCB.jpg](https://github.com/lyh111222/PCB-Resistor-dataset/blob/main/Template%20matching/PCB.jpg)

