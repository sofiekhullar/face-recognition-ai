clear all
clc
%Detect objects using Viola-Jones Algorithm
%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
%I = imread('harrymany.jpg');
I = imread('harrypotter.jpg');

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

figure,
imshow(I); hold on

% BB x,y,w,h
for i = 1:size(BB,1)
   
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end

face = I(BB(2):(BB(2) + BB(4)), BB(1):(BB(1) + BB(3)), :);
imshow(face);

title('Face Detection');
hold off;