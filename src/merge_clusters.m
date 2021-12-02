function [pi_merge, u_merge, R_merge] = merge_clusters(pi, u, R, N)
% 
K = size(pi, 1);
pi_merge = pi;
u_merge = u;
R_merge = R;
%%
pi_lm = pi(1) + pi(2);
u_lm = (pi(1)*u(1,:) + pi(2)*u(2,:)) ./ pi_lm;
R_lm = (pi(1)*(R{1} + (u(1) - u_lm)*(u(1) - u_lm)') +...
       pi(2)*(R{2} + (u(2) - u_lm)*(u(2) - u_lm)')) ./ pi_lm;  

d_min = (1/2)*N*pi(1)*log(det(R_lm)./det(R{1})) + (1/2)*N*pi(2)*log(det(R_lm)./det(R{2}));

for L = 1 : K-1
    for m = L+1 : K
        pi_lm = pi(L) + pi(m);
        u_lm = (pi(L)*u(L,:) + pi(m)*u(m,:)) ./ pi_lm;
        R_lm = (pi(L)*(R{L} + (u(L) - u_lm)*(u(L) - u_lm)') +...
                pi(m)*(R{m} + (u(m) - u_lm)*(u(m) - u_lm)')) ./ pi_lm; 
            
        d = (1/2)*N*pi(L)*log(det(R_lm)./det(R{L})) + (1/2)*N*pi(m)*log(det(R_lm)./det(R{m}));
        
        if d <= d_min
            L_min = L;
            m_min = m;
        end
    end
end
%% merge the two clusters
pi_lm = pi(L_min) + pi(m_min);
u_lm = (pi(L_min)*u(L_min,:) + pi(m_min)*u(m_min,:)) ./ pi_lm;
R_lm = (pi(L_min)*(R{L_min} + (u(L_min) - u_lm)*(u(L_min) - u_lm)') +...
        pi(m_min)*(R{m_min} + (u(m_min) - u_lm)*(u(m_min) - u_lm)')) ./ pi_lm;
    
pi_merge(L_min) = pi_lm;
u_merge(L_min,:) = u_lm;
R_merge{L_min} = R_lm;

pi_merge(m_min) = [];
u_merge(m_min,:) = [];
R_merge{m_min} = [];
end