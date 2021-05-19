function sketchrec (inputpath)
Diode = 2;
Amplifier = 1;
debug = false;
show_original = false;
image_origin = im2double(imread(inputpath));
downsize = 1/4;
img_ds = imresize(image_origin,downsize);
figure;imshow(img_ds);
title('Original Image');

display('Processing Image');
%Locally Adaptive Thresholding
tic;
img_gray = rgb2gray(img_ds);
image_th = Locally_adaptive_Threshold(img_gray);
figure; imshow(image_th);

%Segmentation
%Each Component do match component
load('stdelem.mat');
load('svmmodels.mat');
imgbin = 1-image_th;

%filter noise
MajorMinLength = 8;
imgfill = imgbin;

%Filter by Major and Minor Axis Length.
imglabel = bwlabel(imgfill,8);
shapeProps = regionprops(imglabel,'MajorAxisLength','MinorAxisLength');
for nRegion = 1:length(shapeProps)
    idx = find(imglabel == nRegion);
    majorLength = shapeProps(nRegion).MajorAxisLength;
    if (majorLength<MajorMinLength)
        imgfill(idx) = 0;
    end
end

if show_original
    figure;imshow(imgfill);
    title('Filtered image');
    imwrite(imgfill,'filtered.png');
end

imgskele = bwmorph(imgfill,'thin',Inf);
imgspur = bwmorph(imgskele,'spur');
imgspur = bwmorph(imgspur,'spur');
if debug
    plotbranchpoint(imgspur);
end

boundingboxes = getsegment(imgspur);
figure;imshow(img_ds);
hold on;
for numcomponent = 1:size(boundingboxes,1)
    boundingbox = boundingboxes(numcomponent,:);
    xleft = boundingbox(1);
    xright = boundingbox(2);
    ytop = boundingbox(3);
    ybottom = boundingbox(4);
    orientation = boundingbox(5);
    
    for y=ytop:ybottom
        plot(xleft,y,'y');
        plot(xright,y,'y');
    end
    for x=xleft:xright
        plot(x,ytop,'y');
        plot(x,ybottom,'y');
    end
    
    imgcomponent = imgfill(ytop:ybottom,xleft:xright);
    [h,w]=size(imgcomponent);
    component = matchcomponent(models,imgcomponent);
    componentskele = bwmorph(imgcomponent,'thin',Inf);
    img_std = image_std{component};
    E = bwmorph(imgspur, 'endpoints');
    if (orientation == 1)
        if component == Diode
            uppernum=countendpoint(E,ytop,floor((ytop+ybottom)/2),xleft,xright);
            lowernum=countendpoint(E,round((ytop+ybottom)/2),ybottom,xleft,xright);
            if uppernum>lowernum
                img_std = imrotate(img_std,90);
            else
                img_std = imrotate(img_std,270);
            end
            
        else
            if(numel(find(componentskele(1:floor(h/2),:)==1))>numel(find(componentskele(round(h/2):end,:)==1)))
                img_std = imrotate(img_std,270);
            else
                img_std = imrotate(img_std,90);
            end
        end
    else
        if component == Diode
            leftnum = countendpoint(E,ytop,ybottom,xleft,floor((xleft+xright)/2));
            rightnum = countendpoint(E,ytop,ybottom,round((xleft+xright)/2),xright);
            if leftnum>rightnum
                img_std = imrotate(img_std,180);
            end
        else
            if(numel(find(componentskele(:,1:floor(w/2))==1))<numel(find(componentskele(:,round(w/2):end)==1)))
                img_std = imrotate(img_std,180);
            end
        end
    end
    img_bstd = imresize(img_std,[ybottom-ytop,xright-xleft]);
    [y,x] = find(img_bstd~=0);
    y=y+ytop;
    x=x+xleft;
    plot(x,y,'yo','MarkerSize',1);
    display(component);
    
end
hold off;
toc;
end