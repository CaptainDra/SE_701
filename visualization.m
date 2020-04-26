function visualization(f,s,rs,R,J1,L,t)
%���ӻ�
clf(f);
axis off;
axes('xcolor',get(f,'color'),'xtick',[])
axes('ycolor',get(f,'color'),'ytick',[])
hold on;
color = ['b','g','m','c','y','r','k'];
for j = 1: numel(s)
    plot(s(j),0, strcat('.',color(j)),'MarkerSize',30);
    plot([s(j)-rs,s(j)+rs],[0,0],color(j),'linewidth',3);
end

R_real = bar(R(2:end),'r');
set(gca,'Xlim',[0,L],'XTick',0:5:L)
set(gca,'Ylim',[0,30],'YTick',0:5:30)
text (1,25,['t = ' num2str(t,'%0.2f\n')])
text (1,23,['sum of R = ' num2str(sum(R),'%0.2f\n')])
text (1,21,['J = ' num2str(J1/t,'%0.2f\n')])
%text (1,19,['J = ' num2str(J2/t,'%0.2f\n')])
hold off;
drawnow
