clear all
close all

%% read data
load '../Output/generated_data.mat' -ascii

%% initial value
K = 9;
N = size(generated_data, 1);
pi_update = ones(9, 1) / 9;
u_update = generated_data(1:9, :);
R_update = cell(1, 9);
R_update(:) = {diag([1, 1])};
iteration_num = 20;

%% run EM algorithm
t = 0;
MDL_iter = zeros(2, K * iteration_num + K-1);
Rissanen = zeros(K, 1);
for k = K:-1:1
    [pi_est, u_est, R_est, criteria] = EM_algorithm(pi_update, u_update, R_update,...
                                                    generated_data, iteration_num);
    
    % record MDL with EM iteration
    col_range = ((K-k)*iteration_num+1+t:(K-k)*iteration_num+20+t);
    iter_range = ((K-k)*iteration_num+1:(K-k)*iteration_num+20);
    MDL_iter(1, col_range) = iter_range;
    MDL_iter(2, col_range) = criteria;
    
    % record MDL after 20 EM iterations 
    Rissanen(k) = compute_MDL(k, pi_est, u_est, R_est, generated_data);
    
    if k > 1
        % merge clusters
        [pi_update, u_update, R_update] = merge_clusters(pi_est, u_est, R_est, N);
        
        % compute MDL after cluster merging
        t = t + 1;
        col_idx = (K-k)*iteration_num+20+t;
        MDL_iter(1, col_idx) = col_idx - t;
        MDL_iter(2, col_idx) = compute_MDL(k-1, pi_update, u_update, R_update, generated_data);
    end
end

%% Plot MDL versus each EM iteration
figure;
plot(MDL_iter(1,:), MDL_iter(2,:), '-*');
title('MDL versus EM iteration and cluster merge')
xlabel('EM iteration');
ylabel('MDL');
exportgraphics(gca, '../output/MDL_iter.png');

%% Plot the MDL versus K
figure;
plot(1:K, Rissanen', '-o');
title('MDL versus K')
xlabel('K');
ylabel('MDL');
exportgraphics(gca, '../output/MDL_K.png');