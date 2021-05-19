function boundingboxes = getsegment(img)
Lineoffset = 10;
Edgeoffset = 5;
stepSize = 5;
AreaMin = 20;
boundingboxes = [];
boundingbox = [];
[height,width] = size(img);
B = bwmorph(img, 'branchpoints');
E = bwmorph(img, 'endpoints');
[ye,xe] = find(E);
[y,x] = find(B);
yfilter = [];
xfilter = [];

%Filter using neighbor function.
for i=1:length(y)
    if neighborfunction(img,x(i),y(i))==3
        yfilter = [yfilter y(i)];
        xfilter = [xfilter x(i)];
    end
end

%Filter using nearest feature point.
mindistance = Inf(1,length(yfilter));

for index1=1:length(yfilter)
    for index2=1:length(yfilter)
        if (index2 ~= index1)
            distance = norm ([xfilter(index1)-xfilter(index2),yfilter(index1)-yfilter(index2)]);
            if (distance < mindistance(index1))
                mindistance(index1) = distance;
            end
        end
    end
    for index2=1:length(ye)
        distance = norm ([xfilter(index1)-xe(index2),yfilter(index1)-ye(index2)]);
        if (distance < mindistance(index1))
            mindistance(index1) = distance;
        end
    end
end

yfilter2 = [];
xfilter2 = [];

for i=1:length(yfilter)
    if (mindistance(i) > 3)
        yfilter2 = [yfilter2 yfilter(i)];
        xfilter2 = [xfilter2 xfilter(i)];
    end
end
numbranch = length(xfilter2);
A=[xfilter2;yfilter2]';
D = pdist2(A,A);
UpperTriangle = triu(D);
UpperTriangle(UpperTriangle==0)=Inf;
tooclose = find(UpperTriangle<10);
while numel(tooclose)>0
    closepair = tooclose(1);
    [index1,index2]=ind2sub(size(UpperTriangle),closepair);
    xmean = floor((xfilter2(index1)+xfilter2(index2))/2);
    ymean = floor((yfilter2(index1)+yfilter2(index2))/2);
    xfilter2(index1)=xmean;
    yfilter2(index1)=ymean;
    xfilter2(index2)=[];
    yfilter2(index2)=[];
    A=[xfilter2;yfilter2]';
    D = pdist2(A,A);
    UpperTriangle = triu(D);
    UpperTriangle(UpperTriangle==0)=Inf;
    tooclose = find(UpperTriangle<10);
end
while (numbranch > 1)
    dmin = find(UpperTriangle(:)==min(UpperTriangle(:)));
    [rmin,cmin]=ind2sub(size(UpperTriangle),dmin);
    rmin=rmin(1);
    cmin=cmin(1);
    newpair = [xfilter2(rmin), xfilter2(cmin), yfilter2(rmin), yfilter2(cmin)];
    boundingbox = [boundingbox; newpair];
    UpperTriangle(rmin,:)=Inf;
    UpperTriangle(cmin,:)=Inf;
    UpperTriangle(:,rmin)=Inf;
    UpperTriangle(:,cmin)=Inf;
    numbranch=numbranch-2;
end

for i=1:size(boundingbox,1)
    x1=boundingbox(i,1);
    x2=boundingbox(i,2);
    y1=boundingbox(i,3);
    y2=boundingbox(i,4);
    if (abs(x1-x2)<= Lineoffset)
        %Branchpoint aligned vertically
        ytop=max(1,min(y1,y2)-Edgeoffset);
        ybottom=min(max(y1,y2)+Edgeoffset,height);
        xmean = floor((x1+x2)/2);
        xleft = xmean;
        xright = xmean;
        for x=xmean+stepSize:stepSize:width
            if (width-x<=stepSize)
                xright = width;
                break;
            end
            currwindow = img(ytop:ybottom,xright:x);
            nextwindow = img(ytop:ybottom,x:x+stepSize);
            xright = x;
            if(~isempty(find(currwindow~=0))&&isempty(find(nextwindow~=0)))
                break;
            end
        end
        
        for x=xmean-stepSize:-stepSize:1
            if (x<=stepSize)
                xleft = 1;
                break;
            end
            currwindow = img(ytop:ybottom,x:xleft);
            nextwindow = img(ytop:ybottom,x-stepSize:x);
            xleft = x;
            if(~isempty(find(currwindow~=0))&&isempty(find(nextwindow~=0)))
                break;
            end
        end
        newbox = [xleft,xright,ytop,ybottom,1];
        boundingboxes = [boundingboxes; newbox];
    else
        if (abs(y1-y2)<= Lineoffset)
            %Branchpoint aligned horizontally
            xleft=max(1,min(x1,x2)-Edgeoffset);
            xright=min(max(x1,x2)+Edgeoffset,width);
            ymean = floor((y1+y2)/2);
            ytop = ymean;
            ybottom = ymean;
            for y=ymean+stepSize:stepSize:height
                if (height-y<=stepSize)
                    ybottom = height;
                    break;
                end
                currwindow = img(ybottom:y,xleft:xright);
                nextwindow = img(y:y+stepSize,xleft:xright);
                ybottom = y;
                if(~isempty(find(currwindow~=0))&&isempty(find(nextwindow~=0)))
                    break;
                end
            end
            
            for y=ymean-stepSize:-stepSize:1
                if (y<=stepSize)
                    ytop = 1;
                    break;
                end
                currwindow = img(ytop:-1:y,xleft:xright);
                nextwindow = img(y:-1:y-stepSize,xleft:xright);
                ytop = y;
                if(~isempty(find(currwindow~=0))&&isempty(find(nextwindow~=0)))
                    break;
                end
            end
            newbox = [xleft,xright,ytop,ybottom,0];
            boundingboxes = [boundingboxes; newbox];
        end
    end
end

%filter boundingbox that are too small
small = zeros(1,size(boundingboxes,1));
for i=1:size(boundingboxes,1)
    boundingbox = boundingboxes(i,:);
    xleft = boundingbox(1);
    xright = boundingbox(2);
    ytop = boundingbox(3);
    ybottom = boundingbox(4);
    if (xright-xleft)*(ybottom-ytop)<=AreaMin
        small(i)=1;
    end
end
boundingboxes(small==1,:)=[];
%filter large boundingbox that overlap others
overlap = zeros(1,size(boundingboxes,1));
for i=1:size(boundingboxes,1)
    boundingbox = boundingboxes(i,:);
    xleft1 = boundingbox(1);
    xright1 = boundingbox(2);
    ytop1 = boundingbox(3);
    ybottom1 = boundingbox(4);
    for j=1:size(boundingboxes,1)
        if j~=i
            boundingbox = boundingboxes(j,:);
            xleft2 = boundingbox(1);
            xright2 = boundingbox(2);
            ytop2 = boundingbox(3);
            ybottom2 = boundingbox(4);
            if(xleft1<=xleft2 && xright1>=xright2 && ytop1<=ytop2 && ybottom1>=ybottom2)
                overlap(i)=1;
                break;
            end
        end
    end
end
boundingboxes(overlap==1,:)=[];
end