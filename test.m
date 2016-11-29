clear all
clc
%Detect objects using Viola-Jones Algorithm
%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
%I = imread('harrymany.jpg');
Sofie = imread('sofie/1.jpg');

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

figure,
%imshow(I); hold on
 face = [];
 
% BB x,y,w,h
for i = 1:size(BB,1)
    face = I(BB(i,2):(BB(i,2) + BB(i,4)), BB(i,1):(BB(i,1) + BB(i,3)), :);
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end

imshow(face);
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
