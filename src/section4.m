clear all
close all

%% read data
load '../Output/generated_data.mat' -ascii

%% initial value
K = 9;
pi_init = ones(9, 1) / 9;
u_init = generated_data(1:9, :);
R_init = cell(1, 9);
R_init(:) = {diag([1, 1])};
iteration_num = 20;

%% run EM algorithm
[u_est, R_est, pi_est] = EM_algorithm(u_init, R_init, pi_init, generated_data, iteration_num);
