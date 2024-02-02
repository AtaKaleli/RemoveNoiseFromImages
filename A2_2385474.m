
% noisy1.png
clear all; clc;

% Read Image and Plot the image
  noisy1 = imread("noisy1.png");
  

    
% Take a block in the image and Plot the block 
%the noise can be estimated by analyzing the histogram of this block.
  block = noisy1(1045:1145,1240:1290);
    

% Get the histogram of the block 
  h = imhist(block);
  %bar(h); 
%by looking the historgram of the block, I obtained that we have additive
% noise(spatially independent) and the type of the noise is "Uniform" 

%to remove the identified noise, I am gonna use "Arithmetic Mean Filter"
%as it works best for Gaussian and Uniform noise

%for arithmetic filter, I cant use filter2, which is related with
%correlation, so I decided to use my convolution algorithm I used in first
%assignment.

imgRow=size(noisy1,1);%finding size of row and column of noisy1.png
imgCol=size(noisy1,2);

meanFilter=ones(3,3);
meanFilterRow=size(meanFilter,1);%finding size of the  filter
meanFilterCol=size(meanFilter,2);

noisy1=im2double(noisy1);%convert image to double for operations
paddedImage=padarray(noisy1,[1 1],0,"both"); %doing zero padding 
recovered1=zeros([meanFilterRow meanFilterCol]);%creating an empty array that 
% will hold final result 

for i=1:imgRow
    for j=1:imgCol
        sum=0;%here,I created a temporary sum value that will hold the multiplication of pixel values
        for k=1:meanFilterRow%the sum value always equal to 0 after 3x3 matrix multiplication ends
            for l=1:meanFilterCol
               sum=sum+(meanFilter(k,l)*paddedImage(i+k-1,j+l-1));%I store the result of multiplication of pixels here
            end
        end
        recovered1(i,j)=sum;%after reaching 3x3 size, I plugged sum value into my result array, then move 3x3 filter by one
    end
end


recovered1=abs(recovered1);% I am taking the absoulute of the result
%finally, as a Arithmetic mean filter, I need to divide the final result
%with MXN, which is 3x3=9 in my case
recovered1=recovered1/(meanFilterRow*meanFilterCol);
figure;
subplot(1,3,1);
imshow(recovered1);title("recovered1.png");

%the differences between edges of noisy and reconstructed images 
%I take it in comments as assigment did not ask to show the edges

%edges=recovered1-noisy1;
%figure;
%imshow(edges);

% noisy2.png


noisy2 = imread("noisy2.png");



%I create a block from the image to seek the noise type
block = noisy2(50:100,150:200);
    

% Get the histogram of the block 
  h = imhist(block);
  %bar(h);
%It can be seen that image is corrupted by sinosoidal noise. To clarify
%this, I take a histogram of a block from the image, and clearly see that
%it does not matched any kind of additive noise.

%So this means we have periodic noise(spatially dependent) and the type of
%the noise is "Sinosoidal"

%to remove the noise, I need to do following:
    
%Step 1: Compute the shifted DFT of the image using functions fft2 and fftshift
    F=fft2(noisy2);
    F=fftshift(F);
   

%Step 2: Create the bandreject filter
%I chose gaussian because it is the best one compared with ideal and
%butterworth
%I used the bandPassAndRejectFilters from the lecture materials

    row=size(noisy2,1);
    column=size(noisy2,2);
    Hl = bandPassAndRejectFilters('gaussian',row,column,30,2,15) ;

%Step 3: Filter the image by multiplying the filter with shifted DFT of the image
    G = F.*Hl ;

%Step 4: Compute the inverse DFT using ifft2 and abs functions
    G2 = ifft2(G) ;
    G2= abs(G2);
    
%Step 5: Convert double to image using uint8 function    
    recovered2= uint8(255 * mat2gray(G2));

    subplot(1,3,2);
    imshow(recovered2);title("recovered2.png");

%the differences between edges of noisy and reconstructed images 

%I take it in comments as assigment did not ask to show the edges

% edges=recovered2-noisy2;
% figure;
% imshow(edges);

% noisy3.tif

% Read Image and Plot the image
  noisy3 = imread("noisy3.tif");
  %figure;
  %imshow(noisy3);
   
% Take a block in the image and Plot the block 
%the noise can be estimated by analyzing the histogram of this block.
  block = noisy3(121:180,106:118);
    

% Get the histogram of the block 
  h = imhist(block);
  %bar(h); 
%by looking the historgram of the block, I obtained that we have periodic
% noise(spatially dependent) and the type of the noise is "Gaussian"

%the best filter here is to use butterworth notch reject filter as stated
%in the week5 lecture notes. But I could not manage to apply it, so I used
%gaussian bandreject filter, instead of gaussian filter,  when I
%tried the butterworth and ideal, the recovered image is better than
%gaussian, but as we have gaussian noise type, I did not change the type of
%the bandreject filter.

%to remove the noise, I need to do following:
    
%Step 1: Compute the shifted DFT of the image using functions fft2 and fftshift
    F=fft2(noisy3);
    F=fftshift(F);
   

%Step 2: Create the bandreject filter

%I used the bandPassAndRejectFilters from the lecture materials

    row=size(noisy3,1);
    column=size(noisy3,2);
    Hl = bandPassAndRejectFilters('gaussian',row,column,30,2,15) ;

%Step 3: Filter the image by multiplying the filter with shifted DFT of the image
    G = F.*Hl ;

%Step 4: Compute the inverse DFT using ifft2 and abs functions
    G2 = ifft2(G) ;
    G2= abs(G2);
    
%Step 5: Convert double to image using uint8 function    
    recovered3= uint8(255 * mat2gray(G2));

    subplot(1,3,3);
    imshow(recovered3);title("recovered3.tif");

%the differences between edges of noisy and reconstructed images 

%I take it in comments as assigment did not ask to show the edges

 %edges=recovered3-noisy3;
 %figure;
 %imshow(edges);

 
     
    



     
    