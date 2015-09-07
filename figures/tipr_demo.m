function tipr_demo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plots figure 6 (a and b) of the paper but instead of using the integrated
% precision measure uses the temporal integrated precision measure with the 
% skew behaviour defined such that:
%
% pi_1        = 0.0001;
% pi_function = @(t)(floor_to_one(2.^t .* pi_1));
%
% this figure is not present in the paper and is included for demonstration
% purposes.
%
% The temporal integrated precision measure is detailed in Section 3.2 of
% the paper:
%
%   T. Lampert and P. Gancarski, 'The Bane of Skew: Uncertain Ranks and 
%   Unrepresentative Precision'. In Machine Learning 97 (1-2): 5—32, 2014.
%
%
%
%   Copyright 2013
%
%
%   This is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This software is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this software. If not, see <http://www.gnu.org/licenses/>.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


T = 20;           % interval of time [0 T]

% Define the anonymous function describing skew's temporal behaviour
% (exponential in this example)
pi_1        = 0.0001;
pi_function = @(t)(floor_to_one(2.^t .* pi_1));

interpolate = 1;  % Smoother curve but slow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


default_interpreter = get(0, 'DefaultTextInterpreter');
set(0,'DefaultTextInterpreter', 'LaTex');

try
    
    % Add the folder in which the functions are located to the path list
    path(path, '../toolbox');
    
    h1 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Single Scale Gaussian $\tilde{\textrm{P}}$-R Curves, where $\pi(t)=2^{t} \pi_1$ and $\pi_1 = 0.0001$');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($\tilde{P}$)');
    drawnow

    h2 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Centre-Surround $\tilde{\textrm{P}}$-R Curves, where $\pi(t)=2^{t} \pi_1$ and $\pi_1 = 0.0001$');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($\tilde{P}$)');
    drawnow
    
    h3 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('$\tilde{\textrm{P}}$-R Curve of a Random Classifier, where $\pi(t)=2^{t} \pi_1$ and $\pi_1 = 0.0001$');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($\tilde{P}$)');
    drawnow
    
    h4 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Unachievable area of $\tilde{\textrm{P}}$-R Space, where $\pi(t)=2^{t} \pi_1$ and $\pi_1 = 0.0001$');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($\tilde{P}$)');
    drawnow
    
    
    gt = imread('../detector_responses/gt.tif');
    
    cc = jet(double(max(max(gt))));
    
    
    cs_response = imread('../detector_responses/cs_response.tif');
    ga_response = imread('../detector_responses/gauss_response.tif');
    
    
    for i = 1:max(max(gt))
    
        gt_cur = gt;
        gt_cur(gt_cur < i) = 0;
        gt_cur(gt_cur > 0) = 1;
        
        [p, r] = tipr_curve(ga_response(:), gt_cur(:), interpolate, pi_function, T);
        
        figure(h1), plot(r, p, 'color', cc(i,:));
        drawnow


        [p, r] = tipr_curve(cs_response(:), gt_cur(:), interpolate, pi_function, T);

        figure(h2), plot(r, p, 'color', cc(i,:));
        drawnow
    
    end
    
    figure(h1)
    legend({'$\ge 1$','$\ge 2$','$\ge 3$','$\ge 4$','$\ge 5$','$\ge 6$',...
        '$\ge 7$','$\ge 8$','$\ge 9$','$\ge 10$','$\ge 11$','$\ge 12$',...
        '$\ge 13$'}, 'Location', 'SouthWest');
    hold off;
    figure(h2)
    legend({'$\ge 1$','$\ge 2$','$\ge 3$','$\ge 4$','$\ge 5$','$\ge 6$',...
        '$\ge 7$','$\ge 8$','$\ge 9$','$\ge 10$','$\ge 11$','$\ge 12$',...
        '$\ge 13$'}, 'Location', 'SouthWest');
    hold off;
    
    
    [p, r, auc] = tipr_random_classifier(pi_function, T);

    figure(h3), plot(r, p);
    drawnow
    
    [p, r, auc] = tipr_unachievable(pi_function, T);

    figure(h4), plot(r, p);
    drawnow
        

catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);

    rethrow(e)
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);


end