function [pi_est, u_est, R_est, criterium] = EM_algorithm(pi_init, u_init, R_init, data, iteration_num)
% cluster number
disp('Gaussian mixture model info:');
K = size(pi_init, 1);
fprintf('cluster number is: %0d\n', K);
% data dimension
p = size(data, 2);
fprintf('data dimension is: %0d\n', p);
% data number
N = size(data, 1);
fprintf('total data number is: %0d\n', N);
%% Iterations, using sufficient statistics
u_est = u_init;
R_est = R_init;
pi_est = pi_init;
criterium = zeros(1, iteration_num);
for iters = 1:iteration_num
    N_k = zeros(K, 1);
    t_1_k = zeros(K, 2);
    t_2_k = cell(1,K);
    t_2_k(:) = {zeros(2,2)};
    for i = 1:N
        % inference, E-step
        N_k_sum = 0;
        for j = 1:K           
            N_k_sum = N_k_sum + mvnpdf(data(i,:), u_est(j,:), R_est{j})*pi_est(j);
        end
        
        for j=1:K
            p_x_y = mvnpdf(data(i,:), u_est(j,:), R_est{j})*pi_est(j)/N_k_sum;
            N_k(j) = N_k(j) + p_x_y;
            t_1_k(j,:) = t_1_k(j,:) + data(i,:)*p_x_y;
            t_2_k{j} = t_2_k{j} + (data(i,:)'*data(i,:))*p_x_y;
        end 
    end
    
    % update parameters, M-step
    for j = 1:K
        pi_est(j) = N_k(j) / N;
        u_est(j,:) = t_1_k(j,:) / N_k(j);
        R_est{j} = (t_2_k{j}./N_k(j)) - (t_1_k(j,:)'*t_1_k(j,:))./(N_k(j) * N_k(j));
    end
    
    criterium(iters) = compute_MDL(K, pi_est, u_est, R_est, data);
end
end