function imgtemplate = generateTrain(image_origin)
debug = false;
downsize = 1/4;
img_ds = imresize(image_origin,downsize);
if debug
    figure;imshow(img_ds);
    title('Original Image');
end
%Locally Adaptive Thresholding

img_gray = rgb2gray(img_ds);
image_th = Locally_adaptive_Threshold(img_gray);
if debug
    figure;imshow(image_th);
    title('Thresholded Image');
end
%Segmentation
%Each Component do match component
load('stdelem.mat');
load('svmmodels.mat');
imgbin = 1-image_th;

%filter noise
MajorMinLength = 8;
imgfill = imgbin;
imglabel = bwlabel(imgfill,8);
shapeProps = regionprops(imglabel,'MajorAxisLength');
for nRegion = 1:length(shapeProps)
    idx = find(imglabel == nRegion);
    majorLength = shapeProps(nRegion).MajorAxisLength;
    if (majorLength<MajorMinLength)
        imgfill(idx) = 0;
    end
end
if debug
    figure;imshow(imgfill);
    title('Filtered image');
end

shapeProps = regionprops(imgfill,'BoundingBox');
boundingbox=shapeProps.BoundingBox;
x=floor(boundingbox(1));
y=floor(boundingbox(2));
xwidth=boundingbox(3);
ywidth=boundingbox(4);
% fprintf('x=%d, y=%d, xwidth=%d, ywidth=%d\n', x, y, xwidth, ywidth);
imgbound = imgfill(y-1:y+ywidth+1,x-1:x+xwidth+1);
ratio = 90/max(xwidth,ywidth);
if debug
    figure;imshow(imgbound)
end

% imgresized = imresize(imgbound,[90 90]);
imgresized = imresize(imgbound,ratio);

if debug
    figure;imshow(imgresized);
end
[h,w]=size(imgresized);
imgtemplate = zeros(100,100);
y=50-floor(h/2):49-floor(h/2)+h;
x=50-floor(w/2):49-floor(w/2)+w;
% display(size(x));
% display(size(y));
% display(h);
% display(w);
imgtemplate(y, x) = imgresized;
if debug
    figure;imshow(imgtemplate);
end
end



