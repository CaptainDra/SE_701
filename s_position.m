function P =  s_position(omega,s,r) %�ȷ�λ��,sλ�ã���λ����Ϣ
p = zeors(length(omega)); %��ʼ�� ����
p = max(1-abs(omega-s)/r,0); %Ŀ��ÿ��λ�õ�
P = 1 - prod(1-p,1);%��һ��λ��