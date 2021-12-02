function [criterium] = compute_MDL(K, pi, u, R, y)
% data number
N = size(y, 1);

% data dimension
M = size(y, 2);

%
L = K*(1 + M + (M + 1) * M / 2) - 1;
%%
p_y = 0;
tmp = 0;
for n = 1:N
  for k = 1:K
      p_y = double(p_y) + mvnpdf(y(n,:), u(k,:), R{k})*pi(k);
  end
  tmp = tmp + log(p_y);
  p_y = 0;
end
criterium = -1 * tmp + (1/2) * L * log(M * N);
end