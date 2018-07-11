function isSecond = phase180(dp1,dp2)
    PB1 = sum(sum(dp1(2:2:end, 1:2:end).^2,1),2);
    PG1 = sum(sum(dp1(1:2:end, 1:2:end).^2,1),2);
    PB2 = sum(sum(dp2(2:2:end, 1:2:end).^2,1),2);
    PG2 = sum(sum(dp2(1:2:end, 1:2:end).^2,1),2);
    isSecond = PB2 > PB1 .* PG2 ./ PG1;
end

