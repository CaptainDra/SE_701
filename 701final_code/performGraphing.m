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