FDetect = vision.CascadeObjectDetector;
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);

size = 10;

meanFace = zeros(size,1);
noseWidth = zeros(size,1);
eyeWidth = zeros(size,1);

for i = 1:size
    %path = sprintf('sofie/%d.jpg', i);
    path = sprintf('test/%d.jpg', i);
    image = imread(path);
    
    BBface = step(FDetect,image);
    face = image(BBface(1,2):(BBface(1,2) + BBface(1,4)), BBface(1,1):(BBface(1,1) + BBface(1,3)), :);
    face = imresize(face,[500 500]);
    
    BBnose = step(NoseDetect,face);
    %nose = face(BBnose(1,2):(BBnose(1,2) + BBnose(1,4)), BBnose(1,1):(BBnose(1,1) + BBnose(1,3)), :);
    noseWidth(i) = BBnose(3);  
    
    BBeye = step(EyeDetect, face);
    %eye = face(BBeye(1,2):(BBeye(1,2) + BBeye(1,4)), BBeye(1,1):(BBeye(1,1) + BBeye(1,3)), :);
    eyeWidth(i) = BBeye(3);
end

%%
data = [noseWidth(:,1),eyeWidth(:,1)];

[idx, centroids] = kmeans(data, 2);

x = data(:,1);
y = data(:,2);

figure;
hold on;
colors = 'rgbk';
for num = 1 : 2
    plot(x(idx == num), y(idx == num), [colors(num) '.']);
end

plot(centroids(:,1), centroids(:,2), 'c.', 'MarkerSize', 14);
grid;

%%
clear all
clc
%Detect objects using Viola-Jones Algorithm
%To detect Face
FDetect = vision.CascadeObjectDetector;
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);

%Read the input image
%I = imread('harrymany.jpg');

sofie = imread('sofie/15.jpg');
sofie2 = imread('sofie/4.jpg');
love = imread('love/test/12.jpg');

sofieGray = rgb2gray(sofie);
sofie2Gray = rgb2gray(sofie2);
loveGray = rgb2gray(love);

sofieTh = im2bw(sofie);

%Returns Bounding Box values based on number of objects
BB1 = step(FDetect,sofie);
BB2 = step(FDetect,sofie2);
BB4 = step(FDetect,love);

%figure,
%imshow(sofie); hold on

% BB x,y,w,h
sofieFace = sofie(BB1(1,2):(BB1(1,2) + BB1(1,4)), BB1(1,1):(BB1(1,1) + BB1(1,3)), :);
sofieFace2 = sofie2(BB2(1,2):(BB2(1,2) + BB2(1,4)), BB2(1,1):(BB2(1,1) + BB2(1,3)), :);

sofieFace = imresize(sofieFace,[500 500]);
sofieFace2 = imresize(sofieFace2,[500 500]);

loveFace = love(BB4(1,2):(BB4(1,2) + BB4(1,4)), BB4(1,1):(BB4(1,1) + BB4(1,3)), :);
loveFace = imresize(loveFace,[500 500]);

meanSofie = mean2(sofieFace);

BB3 =step(NoseDetect,sofieFace);
BB5 =step(NoseDetect,sofieFace2);
BB6 =step(NoseDetect, loveFace);

sofieNose = sofieFace(BB3(1,2):(BB3(1,2) + BB3(1,4)), BB3(1,1):(BB3(1,1) + BB3(1,3)), :);
sofieNose2 = sofieFace2(BB5(1,2):(BB5(1,2) + BB5(1,4)), BB5(1,1):(BB5(1,1) + BB5(1,3)), :);

loveNose = loveFace(BB6(1,2):(BB6(1,2) + BB6(1,4)), BB6(1,1):(BB6(1,1) + BB6(1,3)), :);

BB4 = step(EyeDetect, sofieFace);
BB8 = step(EyeDetect, sofieFace2);

sofieEye = sofieFace(BB4(1,2):(BB4(1,2) + BB4(1,4)), BB4(1,1):(BB4(1,1) + BB4(1,3)), :);
sofie2Eye = sofieFace(BB8(1,2):(BB8(1,2) + BB8(1,4)), BB8(1,1):(BB8(1,1) + BB8(1,3)), :);

BBeye = step(EyeDetect, loveFace);
loveEye = loveFace(BBeye(1,2):(BBeye(1,2) + BBeye(1,4)), BBeye(1,1):(BBeye(1,1) + BBeye(1,3)), :);

meanSofieEye = mean2(sofieEye);
meanSofie2Eye = mean2(sofie2Eye);
meanLoveEye = mean2(loveEye);

%%
% Find eye distance
sofieEyeTh = im2bw(loveEye, 0.3);
[m, n] = size(sofieEyeTh);
half = ceil(m/2);
test = sofieEyeTh(half,:);


i = 1;
valueStart = 1;
while test(1,i) == 1
    valueStart = i;
    i = i + 1;
end

k = n;
valueEnd = n;
while test(1,k) == 1
    valueEnd = k;
    k = k - 1;
end

distanceEye = valueEnd - valueStart;

%% Plotting

rectangle('Position',BB1(1,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
imshow(im2bw(sofieFace));
rectangle('Position',BB3(1,:),'LineWidth',2,'LineStyle','-','EdgeColor','r');
imshow(sofieNose);
rectangle('Position',BB4(1,:),'LineWidth',2,'LineStyle','-','EdgeColor','r');
imshow(im2bw(sofieEye));
title('Face Detection');
hold off;
