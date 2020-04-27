function f = numericalOutput(agentPosition1, agentPosition2,agentPosition3,agentPosition4)
    f2 = figure(2);
    axis([0 length(agentPosition1) 0 30]);
    f2 = plot(agentPosition1,'color', [0.8500 0.3250 0.0980],'LineWidth',1.5);
    hold on;
    f2 = plot(agentPosition2, 'color',[0.4660 0.6740 0.1880],'LineWidth',1.5);
    hold on;
    f2 = plot(agentPosition3, 'color',[0.9290 0.6940 0.1250],'LineWidth',1.5);
    hold on;
    f2 = plot(agentPosition4, 'color',[0.6350 0.0780 0.1840],'LineWidth',1.5);
    title('Agent position vs. time');
    xlabel('Time t');
    ylabel('Agent position');
    legend('agent1', 'agent2','agent3', 'agent4');
end