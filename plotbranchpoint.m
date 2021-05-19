function plotbranchpoint(skel)
B = bwmorph(skel, 'branchpoints');
E = bwmorph(skel, 'endpoints');
[ye,xe] = find(E);
figure;imshow(skel);
hold on;
plot(xe,ye,'bo','MarkerSize',10,'MarkerFaceColor','b');
[y,x] = find(B);
yfilter = [];
xfilter = [];
%Filter using neighbor function.
for i=1:length(y)
    if neighborfunction(skel,x(i),y(i))~=2&&neighborfunction(skel,x(i),y(i))~=4
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

plot(xfilter2,yfilter2,'ro','MarkerSize',10,'MarkerFaceColor','r');
hold off;
saveas(gcf,'branchpoint.png');
end