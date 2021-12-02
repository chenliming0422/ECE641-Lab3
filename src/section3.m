clear all
close all

%% generate data
mk_data;

figure;
plot(x(:,1),x(:,2),'o');
title('Scatter Plot of Multimodal Data')
xlabel('first component')
ylabel('second component')
exportgraphics(gca, '../output/scatter_data.png');

%% run EM algorithm
% initialize
pi_init = [1/3; 1/3; 1/3];
R_init = cell(1, 3);
R_init(:) = {diag([1, 1])};
u_init = [x(1,:); x(2,:); x(3,:)];
iteration_num = 20;
%
[pi_est, u_est, R_est] = EM_algorithm(pi_init, u_init, R_init, x, iteration_num);
