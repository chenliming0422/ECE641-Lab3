clear all
close all

mk_data;

figure;
plot(x(:,1),x(:,2),'o');
title('Scatter Plot of Multimodal Data')
xlabel('first component')
ylabel('second component')
exportgraphics(gca, '../output/scatter_data.png');


