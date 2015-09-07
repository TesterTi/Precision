function figure9


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recreates figure 9 of the paper:
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



default_interpreter = get(0, 'DefaultTextInterpreter');
set(0,'DefaultTextInterpreter', 'LaTex');

try
    
    % Add the folder in which the functions are located to the path list
    path(path, '../toolbox');  
    

    h1 = figure;
    axis square
    axis([0 1 0 1]);
    hold on
    title('Figure 9: Minimum Achievable $\bar{\textrm{P}}$recision Recall Curves and Performances of Random Classifiers');
    xlabel('Recall ($R$)');
    ylabel('Precision ($\bar{P}$)');

    
    [p, r, au] = ipr_unachievable(0.6, 0.9);
    figure(h1), plot(r, p, 'b');
    drawnow;
    [p, r, au] = ipr_unachievable(0.3, 0.5);
    figure(h1), plot(r, p, 'r');
    drawnow;
    [p, r, au] = ipr_unachievable(0.0, 0.5);
    figure(h1), plot(r, p, 'k');
    drawnow;
    
    
    [p, r, au] = ipr_random_classifier(0.6, 0.9);
    figure(h1), plot(r, p, '--b');
    drawnow;
    [p, r, au] = ipr_random_classifier(0.3, 0.5);
    figure(h1), plot(r, p, '--r');
    drawnow;
    [p, r, au] = ipr_random_classifier(0.0, 0.5);
    figure(h1), plot(r, p, '--k');
    hold off
    drawnow;
    
    
    legend({'$\pi_1=0.6, \pi_2=0.9$', '$\pi_1=0.3, \pi_2=0.5$'...
        '$\pi_1=0.0, \pi_2=0.5$'}, 'Location', 'NorthEast');
    
catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);
    
    rethrow(e);
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);

end