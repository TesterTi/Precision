function figure4


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recreates figure 4 (a & b) of the paper:
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
    
    
    figure;
    axis square
    axis([0 1 0 1]);
    hold on
    title('Figure 4: Precision Transformed Between Skews');
    xlabel('$P_\pi(\theta)$');
    ylabel('$P_{\pi''}(\theta)$');
    
    
    
    p = 0 : 0.001 : 1;

    [p_p] = p_skew_transform(p, 0.5, 0.4);

    plot(p, p_p, '-k');

    [p_p] = p_skew_transform(p, 0.5, 0.25);

    plot(p, p_p, '-g');

    [p_p] = p_skew_transform(p, 0.5, 0.1);

    plot(p, p_p, '-b');

    [p_p] = p_skew_transform(p, 0.5, 0.01);

    plot(p, p_p, '-r');
    
    
    
    [p_p] = p_skew_transform(p, 0.01, 0.5);

    plot(p, p_p, '--r');

    [p_p] = p_skew_transform(p, 0.01, 0.1);

    plot(p, p_p, '--b');

    [p_p] = p_skew_transform(p, 0.01, 0.02);

    plot(p, p_p, '--g');

    [p_p] = p_skew_transform(p, 0.01, 0.0125);

    plot(p, p_p, '--k');



    legend({'$\pi = 0.5$, $\pi'' = 0.4$', ...
            '$\pi = 0.5$, $\pi'' = 0.25$', ...
            '$\pi = 0.5$, $\pi'' = 0.1$', ...
            '$\pi = 0.5$, $\pi'' = 0.01$', ...
            '$\pi = 0.01$, $\pi'' = 0.5$', ...
            '$\pi = 0.01$, $\pi'' = 0.1$', ...
            '$\pi = 0.01$, $\pi'' = 0.02$', ...
            '$\pi = 0.01$, $\pi'' = 0.0125$'}, ...
            'Location', 'NorthEastOutside');
    
    hold off
    
catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);
    
    rethrow(e);
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);

end