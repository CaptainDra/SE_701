function J = cost(omega,s) %��ʱ�ǼٵĹ���
J = zero(1,length(omega))
for i = 1:length(s)
    J = J + abs(omega - s(i))*abs(omega - s(i)); %u�Ļ��ѣ�
end

