function component = matchcomponent(models,img)
debug = false;
Capacitorindex = 4;
Powerindex = 5;

imgdilate = imdilate(img, ones(8,8));
if debug
    figure;imshow(imgdilate);
end

imglabel = logical(bwlabel(imgdilate,8));
shapeProps = regionprops(imglabel,'MajorAxisLength');
if (length(shapeProps)==2)
    majorLengths = zeros(1,length(shapeProps));
    for nRegion = 1:length(shapeProps)
        majorLengths(nRegion) = shapeProps(nRegion).MajorAxisLength;
    end
    ratio = majorLengths(1)/majorLengths(2);
    if (ratio>1.2||ratio<0.8)
        component = Powerindex;
    else
        component = Capacitorindex;
    end
else
    
    imgbound = img;
    [ywidth,xwidth]=size(img);
    ratio = 90/max(xwidth,ywidth);
    imgresized = imresize(imgbound,ratio);
    
    if debug
        figure;imshow(imgresized);
    end
    [h,w]=size(imgresized);
    imgbw = zeros(100,100);
    y=50-floor(h/2):49-floor(h/2)+h;
    x=50-floor(w/2):49-floor(w/2)+w;
    imgbw(y, x) = imgresized;
    nd = 16;
    [B,L] = bwboundaries(imgbw,'noholes');
    s=[];
    for k = 1:length(B)
        boundary = B{k};
        s =[s;boundary];
    end
    if debug
        plotboundaries(s);
    end
    z=frdescp(s);
    zmag = abs(z);
    zmag = zmag/zmag(2);
    zsel = zmag(3:nd);
    
    component = multisvmtest(models,zsel');
end
end