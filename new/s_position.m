function P =  s_position(X,s,r) %x,sn��rn, ����equation(4)
p = zeros(length(s),length(X)); 

for j = 1:length(s)
    p(j,:) = max(1-abs(X-s(j))/r,0); %Ŀ��ÿ��λ�õ�
end

P = 1 - prod(1-p,1);