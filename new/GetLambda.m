function [lambdasn, lambdai] =GetLambda(target,s,B,rs,lambdasn,lambdai,dt,range) %single agent, multi-agents should be ok
%{
if lambda == 0
    randoml = rand;
    if randoml > 0.5
        lambda = lambda + 1;
    else
        lambda = lambda - 1;
    end
end
%}
%lambdaidot = -1;
%lambdai = lambdai + lambdaidot * dt;
lambdasndot = zeros(length(s));
for i = 1:length(target)
    lambdai(i) = lambdai(i) - 1 * dt;
end
for i = 1:length(target)
    for j = 1:length(s)
        if i >= (j - 1) * range && i <= j * range
            lambdasndot(j) = lambdasndot(j) + lambdai(i) * abs(target(i)-s(j))*B/rs*(target(i)-s(j));
        end
    end
end
for j = 1:length(s)
    lambdasn(j) = lambdasn(j) + lambdasndot(j) * dt;
end

