function [A,B] = RANSAC(I1,I2,n,k,t,d)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Given:
%    RANSAC von SURF feature detection, randon select 4 pair matched Point to estimate the model   
%    data – a set of observed data points
%    model – a model that can be fitted to data points
%    n – minimum number of data points required to fit the model
%    k – maximum number of iterations allowed in the algorithm
%    t – threshold value to determine when a data point fits a model
%    d – number of close data points required to assert that a model fits well to data

% Return:
%    bestfit – model parameters which best fit the data (or nul if no good model is found)
    
    iterations = 0
    bestfit = nul
    besterr = something really large
while iterations < k {
    maybeinliers = n randomly selected values from data
    maybemodel = model parameters fitted to maybeinliers
    alsoinliers = empty set
    for every point in data not in maybeinliers {
        if point fits maybemodel with an error smaller than t
             add point to alsoinliers
    }
    if the number of elements in alsoinliers is > d {
        % this implies that we may have found a good model
        % now test how good it is
        bettermodel = model parameters fitted to all points in maybeinliers and alsoinliers
        thiserr = a measure of how well model fits these points
        if thiserr < besterr {
            bestfit = bettermodel
            besterr = thiserr
        }
    }
    increment iterations
}
return bestfit





end