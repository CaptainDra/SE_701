function f = numericalOutput(agentPosition)
    f2 = figure(2);
    axis([0 length(agentPosition) 0 30]);
    f2 = plot(agentPosition,'color', [0.8500 0.3250 0.0980]);
    hold on;
    title('Agent position vs. time');
    xlabel('Time t');
    ylabel('Agent position');
end