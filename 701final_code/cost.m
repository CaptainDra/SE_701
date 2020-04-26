function J = cost(omega,s) %暂时是假的功能
J = zero(1,length(omega))
for i = 1:length(s)
    J = J + abs(omega - s(i))*abs(omega - s(i)); %u的花费？
end

