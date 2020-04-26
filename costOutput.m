function f = costOutput (cost)
    f3 = figure(3);
    f3 = plot(cost)
    title('Cost J vs. Number of iterations');
    xlabel('Time');
    ylabel('Cost J');
end