%% Read in data

clc
clear all
close all

nr_img = 100;
h_nr = 50;

detector = buildDetector();

nosesWidth = zeros(nr_img,1);
nosesHeight = zeros(nr_img,1);
nosesColor = zeros(nr_img,1);

leftEyeWidth = zeros(nr_img,1);
leftEyeHeight = zeros(nr_img,1);
leftEyeColor = zeros(nr_img,1);

mouthWidth = zeros(nr_img,1);
mouthHeight = zeros(nr_img,1);
mouthColor = zeros(nr_img,1);

eyesSpace = zeros(nr_img,1);

% Read in Love
for i = 1:h_nr
    path = sprintf('love/%d.jpg', i);
    img = imread(path);
    
    [bbox bbimg faces bbfaces] = detectFaceParts(detector,img,2);
    
    [n,m] = size(bbox);
    if(n ~= 0)
        face = img(bbox(1,2):bbox(1,2)+bbox(1,4)-1,bbox(1,1):bbox(1,1)+bbox(1,3)-1,:);
        leftEye = img(bbox(1,6):bbox(1,6)+bbox(1,8)-1,bbox(1,5):bbox(1,5)+bbox(1,7)-1,:);
        rightEye = img(bbox(1,10):bbox(1,10)+bbox(1,12)-1,bbox(1,9):bbox(1,9)+bbox(1,11)-1,:);
        mouth = img(bbox(1,14):bbox(1,14)+bbox(1,16)-1,bbox(1,13):bbox(1,13)+bbox(1,15)-1,:);
        nose = img(bbox(1,18):bbox(1,18)+bbox(1,20)-1,bbox(1,17):bbox(1,17)+bbox(1,19)-1,:);
        %imshow(nose);

        nosesWidth(i) = bbox(1,19);
        nosesHeight(i) = bbox(1,20);
        nosesColor(i) = mean2(nose);

        leftEyeWidth(i) = bbox(1,8);
        leftEyeHeight(i) = bbox(1,9);
        leftEyeColor(i) = mean2(leftEye);
        eyesSpace(i) = abs(((bbox(1,6)+bbox(1,8)) - bbox(1,10)));

        mouthWidth(i) = bbox(1,16);
        mouthHeight(i) = bbox(1,17);
        mouthColor(i) = mean2(mouth);
    end
end


%% Read in Sofie
for i = 1:h_nr

    path = sprintf('sofie/%d.jpg', i);
    img = imread(path);
    
    [bbox bbimg faces bbfaces] = detectFaceParts(detector,img,2);
    
    [n,m] = size(bbox);
    
    if(n ~= 0)
        face = img(bbox(1,2):bbox(1,2)+bbox(1,4)-1,bbox(1,1):bbox(1,1)+bbox(1,3)-1,:);
        leftEye = img(bbox(1,6):bbox(1,6)+bbox(1,8)-1,bbox(1,5):bbox(1,5)+bbox(1,7)-1,:);
        rightEye = img(bbox(1,10):bbox(1,10)+bbox(1,12)-1,bbox(1,9):bbox(1,9)+bbox(1,11)-1,:);
        mouth = img(bbox(1,14):bbox(1,14)+bbox(1,16)-1,bbox(1,13):bbox(1,13)+bbox(1,15)-1,:);
        nose = img(bbox(1,18):bbox(1,18)+bbox(1,20)-1,bbox(1,17):bbox(1,17)+bbox(1,19)-1,:);

        nosesWidth(i+h_nr) = bbox(1,19);
        nosesHeight(i+h_nr) = bbox(1,20);
        nosesColor(i+h_nr) = mean2(nose);

        leftEyeWidth(i+h_nr) = bbox(1,8);
        leftEyeHeight(i+h_nr) = bbox(1,9);
        leftEyeColor(i+h_nr) = mean2(leftEye);
        eyesSpace(i+h_nr) = abs(((bbox(1,6)+bbox(1,8)) - bbox(1,10)));

        mouthWidth(i+h_nr) = bbox(1,16);
        mouthHeight(i+h_nr) = bbox(1,17);
        mouthColor(i+h_nr) = mean2(mouth);
    end
end

%% Create the plot
close all
data = [mouthWidth(:,1),leftEyeWidth(:,1), nosesColor(:,1)];

x = data(1:h_nr,1);
y = data(1:h_nr,2);
z = data(1:h_nr,3);

scatter3(x, y, z, 10, 'red');

x1 = data(h_nr+1:nr_img,1);
y1 = data(h_nr+1:nr_img,2);
z1 = data(h_nr+1:nr_img,3);

hold on
scatter3(x1,y1,z1, 10, 'b');

meanLove = [mean2(data(1:h_nr,1)), mean2(data(1:h_nr, 2)),mean2(data(h_nr:nr_img, 3))];
meanSofie = [mean2(data(h_nr+1:nr_img,1)), mean2(data(h_nr+1:nr_img, 2)),mean2(data(h_nr+1:nr_img, 3))];
hold on
scatter3(meanSofie(1, 1), meanSofie(1, 2), meanSofie(1, 3), 80, 'blue');
scatter3(meanLove(1, 1), meanLove(1, 2), meanLove(1, 3), 80, 'red');
correctSofie = 0;
correctLove = 0;


for i = 1:h_nr
    if(sqrt((power(data(i, 1) - meanSofie(1, 1),2))+(power(data(i, 2) - meanSofie(1, 2),2))+(power(data(i, 3) - meanSofie(1, 3),2))) < sqrt((power(data(i, 1) - meanLove(1, 1),2))+(power(data(i, 2) - meanLove(1, 2),2))+(power(data(i, 3) - meanLove(1, 3),2))))
        correctSofie = correctSofie + 1;
    end
end

for i = h_nr+1:nr_img
    if(sqrt((power(data(i, 1) - meanSofie(1, 1),2))+(power(data(i, 2) - meanSofie(1, 2),2))+(power(data(i, 3) - meanSofie(1, 3),2))) < sqrt((power(data(i, 1) - meanLove(1, 1),2))+(power(data(i, 2) - meanLove(1, 2),2))+(power(data(i, 3) - meanLove(1, 3),2))))
        correctLove = correctLove + 1;
    end
end

correctLove
correctSofie


%% Test one dataset

close all
oneValues = ones(70,1);
data = [oneValues(:,1),mouthColor(:,1)];
x = data(1:35,1);
y = data(1:35,2);

scatter(x, y, 10, 'red');

x1 = data(36:70,1);
y1 = data(36:70,2);
hold on
scatter(x1,y1, 10, 'b');

meanLove = [1, mean2(data(1:35, 2))];
meanSofie = [1, mean2(data(36:70, 2))];
hold on
scatter(1, meanSofie(1, 2), 80, 'blue');
scatter(1, meanLove(1, 2), 80, 'red');
correctSofie = 0;
correctLove = 0;


for i = 1:35
    if(abs(data(i,2) - meanSofie(1,2)) > abs(data(i,2) - meanLove(1,2)))
        correctLove = correctLove + 1;
    end
end

for i = 36:70
    if(abs(data(i,2) - meanSofie(1,2)) < abs(data(i,2) - meanLove(1,2)))
        correctSofie = correctSofie + 1;
    end
end

correctLove
correctSofie

%% Plot face with bbox
for i=1:size(bbfaces,1)
 figure;imshow(bbfaces{i});
 face = bbfaces{1};
end

%%

%meanSofie = [mean2(data(1:15,1)), mean2(data(1:15, 2))];
%meanLove = [mean2(data(16:30,1)), mean2(data(16:30, 2))];
meanSofie = [mean2(data(1:15,1)), mean2(data(1:15, 2))];
meanLove = [mean2(data(16:30,1)), mean2(data(16:30, 2))];
hold on
scatter(meanSofie(1, 1), meanSofie(1, 2));
scatter(meanLove(1, 1), meanLove(1, 2));

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