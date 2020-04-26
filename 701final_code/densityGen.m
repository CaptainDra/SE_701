function [V,alpha] = densityGen(theta_init_a, theta_init_b,R0,r)


V = zeros(1,length(R0));
tarpos = find(R0)-1;
alpha = ones(1,length(tarpos));
%alpha = exp(R0(tarpos + 1));
%alpha = alpha./sum(alpha); 
for i = 1: length(tarpos)

for w = theta_init_a  : theta_init_b 
    %di = max([r,abs(w-tarpos(i))]);
    %R(w+1) = R(w+1) +  alpha(i) * R0(tarpos(i)+1) / di;
    di = abs(w-tarpos(i));
    V(w+1) = V(w+1) +  alpha(i) * R0(tarpos(i)+1) / exp(di);
end


end