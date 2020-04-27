clear;clc;
close all
N = 4; %assume there are five agents right now

T = 3;  %Time
dt = 0.01;
n = 301; 
t = linspace(0,T,n);

L = 30; %length for figure
omega = 0:L; %divide

%target = [5,10,15];  

s_num = 1;
s_init = linspace(0,L,s_num);
u_init = zeros(1,s_num);
%target = [5,10,15,20,25];
target = 1:30;  %30 bar sample
f = figure(1);
R0=zeros(1,L+1); %measure of uncertainty at each sampling point
R0(target) = 1;%initial of R
R = R0;
R1 = R0;
A0=zeros(1,L+1); %complexity increasing rate
A0(target) = 10; 
A0 = randi([1 10],1,L+1);%random A
rs= 3;
J1 = 0; % J of R
J2 = 0; % J for current time
J3 = 0; 
J4 = 0;
B= 100;
J0 = 0;

boundary = [max(min(target)-rs,0),min(max(target)+rs,L)]; %boundary for V

% R traj
% M =[]; % video record
R_est = repmat(R0,N,1);
V_est = zeros(N, L + 1);
R_est_h = R_est; R_h = R0;  % R traj record
r_d = 1;
limitRange = 1;
%s = zeros(1,N); %initial position
%s initialization 
s = [2,8,16,23];
s1 = s;
%s depends on u(velocity), which is 1 or -1

axis([0 L+2 0 5]);
gra = bar(R0);
axis([0 L+2 0 5]);
%hold on;
s_path1 = zeros(1, T*100);
s_path2 = zeros(1, T*100);
s_path3 = zeros(1, T*100);
s_path4 = zeros(1, T*100);
cost = zeros(1, T*100);
help = 0;

u1 = [1,1,1,1];
sl = [0,0,0,0];
sll = [0,0,0,0];
slll = [0,0,0,0];
lambdasn = zeros(1,length(s));
lambdai = zeros(1,length(target));
range = L/4;
for i = t
    for j = 1 : N
        R_est(j,(target(abs(s(j)-target) < rs)+1)) = R(target(abs(s(j)-target) < rs)+1);
    end
    P = s_position(omega,s,rs);
    R = R + A0.*dt; 
    R  = max(R - B.*P*dt,0);
    [V,~] = densityGen(boundary(1), boundary(2),R,r_d);
    J1 = J1 + sum(R)*dt;
    J2 = sum(R);
    visualization(f,s,rs,R,J1,J2,L,i+dt);
    %{
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
    help = help + 1;
    cost(help) = J2;
    if help > 1
        sl(1) = s_path1(help - 1);
        sl(2) = s_path2(help - 1);
        sl(3) = s_path3(help - 1);
        sl(4) = s_path4(help - 1);
    end
    if help > 2
        sll(1) = s_path1(help - 2);
        sll(2) = s_path2(help - 2);
        sll(3) = s_path3(help - 2);
        sll(4) = s_path4(help - 2);
    end
    if help > 3
        slll(1) = s_path1(help - 3);
        slll(2) = s_path2(help - 3);
        slll(3) = s_path3(help - 3);
        slll(4) = s_path4(help - 3);
    end
    s_path1(help) = s(1);
    if sll(1) == s_path1(help) && sl(1) == slll(1)
        s_path1(help - 1) = sll(1);
    end
    s_path2(help) = s(2);
    if sll(2) == s_path2(help) && sl(2) == slll(2)
        s_path2(help - 1) = sll(2);
    end
    s_path3(help) = s(3);
    s_path4(help) = s(4);
    u = fakeu(s,V_est,omega);
    s = s + u;
    for w = 1:N
        if s(w) > 7.5 * w
            s(w) = s(w) - 2;
            u(w) = -1;
        end
        if s(w) < 0 + 7.5 * w
            s(w) = s(w) + 2;
            u(w) = 1;
        end
    end
    %}
    
    [lambdasn, lambdai] = GetLambda(target,s,B,rs,lambdasn,lambdai,dt,range);
    for j = 1:N
        s(j) = s(j) - lambdasn(j)/abs(lambdasn(j));
    end
    help = help + 1;
    cost(help) = J2;
    s_path1(help) = s(1);
    s_path2(help) = s(2);
    s_path3(help) = s(3);
    s_path4(help) = s(4);
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
numericalOutput(s_path1, s_path2, s_path3, s_path4);
costOutput(cost);
A0

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
