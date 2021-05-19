function pointtype = neighborfunction(img,x,y)
    neighbor = zeros(1,8);
    neighbor(1) = img(y,x+1);
    neighbor(2:4) = img(y-1,x+1:-1:x-1);
    neighbor(5:6) = img(y:y+1,x-1);
    neighbor(7:8) = img(y+1,x:x+1);
    neighborrot = [neighbor(2:8) neighbor(1)];
    pointtype = 0;
    for i=1:8
        if (neighbor(i)==1&&neighborrot(i)==0)
            pointtype = pointtype+1;
        end
    end
end