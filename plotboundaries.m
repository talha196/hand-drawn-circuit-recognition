function plotboundaries(b)
    figure;clf;hold on;
    for i= 1:size(b,1)
        plot(b(i,1),b(i,2),'LineWidth',2);
    end
    hold off;
end