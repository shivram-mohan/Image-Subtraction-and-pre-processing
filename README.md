Image Subtraction 

In this project we have used various filters to attain the subtracted image and with the help of GUI we have enhanced the user experience while using the application 

here's a self help to understand what's going on in the project 

1)callback function : how the prog responds when we press a button 
                      we can add and remove them too

2)global variable declaration

3)Uploading the images using uigetfile(imread)

4)resizing 2nd image based out of 1st image (imresize)

5)converting the image array (8 or 16) into double precision(64 bits) ranging between  [0,1] (im2double)

6)imsubtract is for subtracting

7)imshow is for displaying 

8) gauss filter - smoothenning or blurr
   (img3,changing value)

we have two options now when contrast is 0 and brightness is needed to be set and when contrast is already set 
and brightness also needs to be set 

9)brightening
   original image + brightened offset 
   max(0,min(brightened image,1)); = to ensure the array value lies in the range 0 to 1 
  
we have two options now when brightness is 0 and contrast is needed to be set and when brightness is already set 
and contrast  also needs to be set 


10) original image * contrasted offset 
    max(0,min(brightened image,1)); = to ensure the array value lies in the range 0 to 1 
  
11) imrite (writes the exported image to the file loaction)

    Thank you!!

