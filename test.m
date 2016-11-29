clear all
clc
%Detect objects using Viola-Jones Algorithm
%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
%I = imread('harrymany.jpg');
sofie = imread('sofie/1.jpg');
love = imread('love/test/1.jpg');

%Returns Bounding Box values based on number of objects
BB1 = step(FDetect,sofie);
BB2 = step(FDetect,love);

figure,
%imshow(I); hold on
 
% BB x,y,w,h
for i = 1:size(BB1,1)
    sofieFace = sofie(BB1(i,2):(BB1(i,2) + BB1(i,4)), BB1(i,1):(BB1(i,1) + BB1(i,3)), :);
    sofieFace = rgb2gray(sofieFace);
  
    loveFace = love(BB2(i,2):(BB2(i,2) + BB2(i,4)), BB2(i,1):(BB2(i,1) + BB2(i,3)), :);
    lovesFace = rgb2gray(loveFace);
    rectangle('Position',BB1(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end


imshow(sofieFace);
title('Face Detection');
hold off;


%%

%To detect Eyes
%EyeDetect = vision.CascadeObjectDetector('EyePairBig');
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);

%Read the input Image
I = imread('harrymany.jpg');

%BB=step(EyeDetect,I);
BB=step(MouthDetect,I);


figure,imshow(I);

% BB x,y,w,h
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','r');
end

%rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
title('Eyes Detection');
Eyes=imcrop(I,BB);
figure,imshow(Eyes);
