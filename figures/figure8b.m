function figure8b


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recreates figure 8b of the paper:
%
%   T. Lampert and P. Gancarski, 'The Bane of Skew: Uncertain Ranks and 
%   Unrepresentative Precision'. In Machine Learning 97 (1-2): 5—32, 2014.
%
% The STARE ground truths (both labels-vk and labels-ah) should be 
% downloaded from:
%
%        http://www.ces.clemson.edu/~ahoover/stare/
%
% and placed into the %toolboxroot%/detector_responses/STARE/GTs
% directory.
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


pi_1 = 0.023;      % Range used in the paper
pi_2 = 0.235;

interpolate = 1;   % Smoother curve but slow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



path(path, '../detector_responses/STARE');
[STARE_d, STARE_gt1, STARE_gt2] = load_STARE;

default_interpreter = get(0, 'DefaultTextInterpreter');
set(0,'DefaultTextInterpreter', 'LaTex');

try
    
    % Add the folder in which the functions are located to the path list
    path(path, '../toolbox');

    
    h1 = figure;
    hold on
    axis square
    axis([0 1 0 1])
    title('Figure 8b: P-R and $\bar{\textrm{P}}$-R curves calculated upon the STARE dataset using the VK (red) and the AH (blue) ground truths.');
    xlabel('Recall ($R$)');
    ylabel('Precision ($P$ and $\bar{P}$)');
    drawnow
    
    
    % Calculate the P-R curves using each ground truth
    [p_STARE1, r_STARE1] = pr_curve(uint8(STARE_d(:)), uint8(STARE_gt1(:)), interpolate);
    figure(h1), plot(r_STARE1, p_STARE1, '--r')
    drawnow
    
    
    [p_STARE2, r_STARE2] = pr_curve(uint8(STARE_d(:)), uint8(STARE_gt2(:)), interpolate);
    figure(h1), plot(r_STARE2, p_STARE2, '--b')
    drawnow
    
    
    % Calculate the iP-R curves using each ground truth
    [ip_STARE1, ir_STARE1] = ipr_curve(uint8(STARE_d(:)), uint8(STARE_gt1(:)), interpolate, pi_1, pi_2);
    figure(h1), plot(ir_STARE1, ip_STARE1, 'r')
    drawnow
    
    
    [ip_STARE2, ir_STARE2] = ipr_curve(uint8(STARE_d(:)), uint8(STARE_gt2(:)), interpolate, pi_1, pi_2);
    figure(h1), plot(ir_STARE2, ip_STARE2, 'b')
    
    
    
    legend({['P-R: $\pi =  ' num2str(sum(sum(STARE_gt1>0))/numel(STARE_gt1)) '$'], ...
            ['P-R: $\pi =  ' num2str(sum(sum(STARE_gt2>0))/numel(STARE_gt2)) '$'], ...
            ['$\bar{\mathrm{P}}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$'], ...
            ['$\bar{\mathrm{P}}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$']}, ...
            'Location', 'SouthWest');
    hold off
    
catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);

    rethrow(e)
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);


end