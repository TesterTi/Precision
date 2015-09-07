function ipr_demo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plots figure 8b of the paper using the integrated precision measure, in 
% addition to the performance of a random classifier and the unachievable 
% area of ipr space.
%
%
% The integrated precision measure is detailed in Section 3.3.2 of the 
% paper:
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


pi_1 = 0.023;    % Range found in Section 4.1
pi_2 = 0.235;

interpolate = 1; % Smoother curve but slow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Original Dataset
path(path, '../detector_responses/STARE');
[STARE_d1, STARE_gt1, STARE_gt2] = load_STARE;


default_interpreter = get(0, 'DefaultTextInterpreter');
set(0,'DefaultTextInterpreter', 'LaTex');

try
    
    % Add the folder in which the functions are located to the path list
    path(path, '../toolbox');

    
    h1 = figure;
    axis square
    axis([0 1 0 1]);
    hold on
    title('$\bar{\textrm{P}}$-R curves calculated upon the STARE dataset');
    xlabel('Recall ($R$)');
    ylabel('Precision ($\bar{P}$)');
    
    h3 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('$\bar{\textrm{P}}$-R Curve of a Random Classifier');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($\bar{P}$)');
    drawnow
    
    h4 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Unachievable area of $\bar{\textrm{P}}$-R Space');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($\bar{P}$)');
    drawnow


    % Calculate the weighted iP-R curves using the original dataset
    [ip_STARE1, ir_STARE1] = ipr_curve(uint8(STARE_d1(:)), uint8(STARE_gt1(:)), interpolate, pi_1, pi_2);
    figure(h1), plot(ir_STARE1, ip_STARE1, 'r')
    drawnow
    
    % Calculate the weighted iP-R curves using the original dataset
    [ip_STARE2, ir_STARE2] = ipr_curve(uint8(STARE_d1(:)), uint8(STARE_gt2(:)), interpolate, pi_1, pi_2);
    figure(h1), plot(ir_STARE2, ip_STARE2, 'b')
    drawnow
    
    % Calculate the weighted iP-R curve for a random classifier
    [p, r] = ipr_random_classifier(pi_1, pi_2);
    figure(h3), plot(r, p);
    drawnow
    
    % Calculate the unachievable area of iP-R space
    [p, r] = ipr_unachievable(pi_1, pi_2);
    figure(h4), plot(r, p);
    drawnow
    
    
    figure(h1)
    legend({['$\bar{P}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$'], ...
            ['$\bar{P}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$']}, ...
            'Location', 'SouthWest');
    hold off

catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);
    
    rethrow(e);
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);

end