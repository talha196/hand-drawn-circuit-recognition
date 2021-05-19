function numofendpoint=countendpoint(E,ytop,ybottom,xleft,xright)
    [ye,xe] = find(E(ytop:ybottom,xleft:xright));
    numofendpoint = numel(xe);
end