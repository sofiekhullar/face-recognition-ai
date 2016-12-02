clc
clear all
close all

nr_images = 30;

detector = buildDetector();
nosesWidth = zeros(nr_images,1);
mouthsMean = zeros(nr_images,1);
spaceEyes = zeros(nr_images,1);
colorEye = zeros(nr_images,1);

for i = 1:nr_images
    path = sprintf('bothlovesofie/%d.jpg', i);
    img = imread(path);
    
    [bbox bbimg faces bbfaces] = detectFaceParts(detector,img,2);
    
    %face = img(bbox(1,2):bbox(1,2)+bbox(1,4)-1,bbox(1,1):bbox(1,1)+bbox(1,3)-1,:);
    leftEye = img(bbox(1,6):bbox(1,6)+bbox(1,8)-1,bbox(1,5):bbox(1,5)+bbox(1,7)-1,:);
    %rightEye = img(bbox(1,10):bbox(1,10)+bbox(1,12)-1,bbox(1,9):bbox(1,9)+bbox(1,11)-1,:);
    %mouth = img(bbox(1,14):bbox(1,14)+bbox(1,16)-1,bbox(1,13):bbox(1,13)+bbox(1,15)-1,:);
    %nose = img(bbox(1,18):bbox(1,18)+bbox(1,20)-1,bbox(1,17):bbox(1,17)+bbox(1,19)-1,:);
    %imshow(nose);
    
    %nosesWidth(i) = bbox(1,19);
    %mouthG = rgb2gray(mouth);
    colorEye(i) = mean2(leftEye); % jag högre värden
    %mouthsMean(i) = mean(mouth(:));
    spaceEyes(i) = abs(((bbox(1,6)+bbox(1,8)) - bbox(1,10))); % jag har något större 
    
    %figure;imshow(bbfaces{1});
end
%%

data = [colorEye(:,1),spaceEyes(:,1)];

[idx, centroids] = kmeans(data, 2);

x = data(:,1);
y = data(:,2);

figure;
hold on;
colors = 'rb';
for num = 1 : 2
    plot(x(idx == num), y(idx == num), [colors(num) '.']);
end

plot(centroids(:,1), centroids(:,2), 'k.', 'MarkerSize', 20);
grid;
%%
data = [colorEye(:,1),spaceEyes(:,1)];
x = data(1:15,1);
y = data(1:15,2);

hold on
scatter(x,y, 10, 'r');

x1 = data(16:30,1);
y1 = data(16:30,2);

scatter(x1,y1, 10, 'b');
%%
%figure;imshow(bbimg);
for i=1:size(bbfaces,1)
 figure;imshow(bbfaces{i});
 face = bbfaces{1};
end


%%
%       bbox(:, 1: 4) is bounding box for face
%       bbox(:, 5: 8) is bounding box for left eye
%       bbox(:, 9:12) is bounding box for right eye
%       bbox(:,13:16) is bounding box for mouth
%       bbox(:,17:20) is bounding box for nose

%face = image(BBface(1,2):(BBface(1,2) + BBface(1,4)), BBface(1,1):(BBface(1,1) + BBface(1,3)), :);
%% Please uncoment to run demonstration of detectRotFaceParts
%{
 img = imrotate(img,180);
 detector = buildDetector(2,2);
 [fp bbimg faces bbfaces] = detectRotFaceParts(detector,img,2,15);

 figure;imshow(bbimg);
 for i=1:size(bbfaces,1)
  figure;imshow(bbfaces{i});
 end
%}