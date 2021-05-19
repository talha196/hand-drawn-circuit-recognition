function outimage = boundimage(img)
offset = 5;
CH = bwconvhull(img);
shapeProps = regionprops(CH,'BoundingBox');
boundingbox = shapeProps.BoundingBox;
x=floor(boundingbox(1));
y=floor(boundingbox(2));
xwidth=boundingbox(3);
ywidth=boundingbox(4);
outimage = img(y-offset:y+ywidth+offset,x-offset:x+xwidth+offset);
end