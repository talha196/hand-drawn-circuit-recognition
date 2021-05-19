function zsel = centroidfr(imgbw)
nd=60;
imgskele = bwmorph(imgbw,'thin',Inf);
imgspur = bwmorph(imgskele,'spur');
[y,x]=find(imgspur==1);
centroidx=mean(x);
centroidy=mean(y);
numofelem=numel(x);
distance=sqrt((y-repmat(centroidy,numofelem,1)).^2+(x-repmat(centroidx,numofelem,1)).^2);
z=fft(distance,nd);
zmag = abs(z);
zmag = zmag/zmag(1);
zsel = zmag(2:nd/2);
end