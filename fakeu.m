function u = fakeu(s,V_est,omega)
for  j = 1 : numel(s)
    u(j) = -sign(sum(V_est(j,:).*sign(s(j)-omega)./(abs(s(j)-omega)+1)) );
end