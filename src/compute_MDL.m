function [criterium] = compute_MDL(K, pi, u, R, y)
% data number
N = size(y, 1);

% data dimension
M = size(y, 2);

%
L = K*(1 + M + (M + 1) * M / 2) - 1;
%%
for n = 1:N
  for k = 1:K
      p_y = p_y + mvnpdf(y(n,:), u(k,:), R{k})*pi(k);
  end
  criterium = criterium - log(p_y);
end
criterium = criterium + (1/2) * L * log(M * N);
end