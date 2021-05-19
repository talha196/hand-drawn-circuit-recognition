function z = frdescp(s)
sizes=size(s,1);
meansx = mean(s(:,1));
meansy = mean(s(:,2));
fu=s(:,1)-repmat(meansx,[sizes,1])+1i*s(:,2)+1i*repmat(meansy,[sizes,1]);
z = fft(fu);
end