clear;clc;
close all
N = 1; %assume there are five agents right now

T = 10;  %Time
dt = 0.01;
n = 1001; 
t = linspace(0,T,n);

L = 30; %整体长度
omega = 0:L; %等分

%target = [5,10,15];  

s_num = 1;
s_init = linspace(0,L,s_num);
u_init = zeros(1,s_num);
target = [5,10,15,20,25];
%target = 1:30;  %这行替换上一行可以开始快乐变卡
f = figure(1);
R0=zeros(1,L+1); %measure of uncertainty at each sampling point
R0(target) = 1;%一开始想设计的中间有距离
R = R0;
A0=zeros(1,L+1); %complexity increasing rate
A0(target) = 10; 
rs= 1;
J1 = 0; % J of R
J2 = 0; % J of travel 这个还没用
B= 100;
J0 = 0;

boundary = [max(min(target)-rs,0),min(max(target)+rs,L)]; %0与L为防止过小过大,但还没用上

% R traj
% M =[]; % video record
R_est = repmat(R0,N,1);
V_est = zeros(N, L + 1);
R_est_h = R_est; R_h = R0;  % R traj record
r_d = 1;
limitRange = 1;
%s = zeros(1,N); %initial position
%s initialization 瞎写的
s = [8];
%s depends on u(velocity), which is 1 or -1

axis([0 L+2 0 5]);
gra = bar(R0);
axis([0 L+2 0 5]);
%hold on;


%u等于正负1，判断依据是lambda，lambda还没写，所以用了rand来代替判定依据
lambdasn = zeros(1,length(s));
lambdai = zeros(1,length(target));
for i = t
    for j = 1 : N
        R_est(j,(target(abs(s(j)-target) < rs)+1)) = R(target(abs(s(j)-target) < rs)+1);
    end
    P = s_position(omega,s,rs);
    R = R + A0.*dt; 
    R  = max(R - B.*P*dt,0);
    [V,~] = densityGen(boundary(1), boundary(2),R,r_d);
    J1 = J1 + sum(R)*dt;
    visualization(f,s,rs,R,J1,L,i+dt);
    for j = 1 : N
        P_est = s_position(omega,s(abs(s - s(j))<2*rs),rs);
        R_est(j,:) = R_est(j,:) + A0.*dt;
        R_est(j,:)  = max(R_est(j,:)  - B.*P_est*dt,0);
        if limitRange ==1
            [V_est(j,:) , ~] = densityGen(max(boundary(1),round(s(j) - 3*rs)), min(round(s(j)+3*rs),boundary(2)),R_est(j,:),r_d);
        else
            [V_est(j,:) , ~] = densityGen(boundary(1), boundary(2),R_est(j,:),r_d);
        end
    end
    u = fakeu(s,V_est,omega);
    s = s + u;
    %{
    [lambdasn, lambdai] = GetLambda(target,s,B,rs,lambdasn,lambdai,dt);
    for j = 1:N
        s(j) = s(j) - lambdasn(j)/abs(lambdasn(j));
    end
    %}
%{    
    for j = 1:N
        l = rand;
        if l > 0.5 && s(j) < L
            s(j) = s(j) + 1;
        elseif l < 0.5 && s(j) > 0
            s(j) = s(j) - 1;
        end
            %pause(0.1);
            %R0 = performGraphing(L,R0,s(j)+1,s);
    end
    sumR = sum(R0);
    J0 = J0 + sumR;
%}
end

J0 = J0 / T   %equation(7)



%Algorithm 1: IPA-based optimization algorithm to find theta star and omega
%star
s = [1,2,3,4,5,6,7,8,9,10]; %temporary s for testing
a = 1;
b = 2;
N = 10;
D = defineD(a, b, N);
sigma = 1;
epsilon = 1;
xi = 1;
theta = defineTheta(D, 2, sigma, xi);
gamma = defineGamma(sigma, D, 20, 2, s);
omega = zeros(1, N);


function f = defineD(a, b, N)
    A = zeros(1, N);
    for i = 1:N
        A(i) = a + (2*i - (1/(2*N))) * (b-a);
    end
    f = A;          
end


function f = defineTheta(D, n, sigma, xi)
    if mod(xi,2)
        f = D(n) - sigma;
    else
        f = D(n) + sigma;
    end
end


function f = defineGamma(sigma, D, T, n, s)
    f = ceil(1/(2 * sigma) * (T - defineTheta(D, n, sigma, 1) + s(n)));
end

function f = performGraphing(L,R0,sn,s)
    axis([0 L+2 0 5]);
    increasingArr = [0.1,0.2,0.3,0.2,0.3,0.1,0.2,0.3,0.2,0.3,0.1,0.2,0.3,0.2,0.3,0.1,0.2,0.3,0.2,0.3,0.1,0.2,0.3,0.2,0.3,0.1,0.2,0.3,0.2,0.3];%应该是公式6 暂时替代
    for j = 1:L
        if j ~= sn
            R0(j) = R0(j) + increasingArr(j);
        elseif j>1 && j <= L
            R0(j-1) = 0;
            R0(j) = 0;
            R0(j+1) = 0;
        end
    end
    gra = bar(R0);
    hold on;
    for i = 1:length(s)
        gra = scatter(s(i),0,100,'filled','d','r');
    end
    axis([0 L+2 0 20]);
    hold off;
    f = R0;
end
