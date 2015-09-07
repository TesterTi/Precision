function figure7b


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recreates figure 7b of the paper:
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


pi_1 = 0.023;    % Range used in the paper
pi_2 = 0.235;

interpolate = 1; % Smoother curve but slow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Original Dataset
path(path, '../detector_responses/STARE');
[STARE_d1, STARE_gt1] = load_STARE;

% Alter the Skew (remove 50% of negative instances)
STARE_gt2 = STARE_gt1(:);
STARE_d2 = STARE_d1(:);
neg_ind = find(STARE_gt2 == 0);
pos_ind = find(STARE_gt2 > 0);
ind = randperm(numel(neg_ind));
neg_ind = neg_ind(ind(1:round(numel(ind)*0.5)));
STARE_gt2 = [STARE_gt2(neg_ind); STARE_gt2(pos_ind)];
STARE_d2 = [STARE_d2(neg_ind); STARE_d2(pos_ind)];


default_interpreter = get(0, 'DefaultTextInterpreter');
set(0,'DefaultTextInterpreter', 'LaTex');

try
    
    % Add the folder in which the functions are located to the path list
    path(path, '../toolbox');

    
    h1 = figure;
    axis square
    axis([0 1 0 1]);
    hold on
    title('Figure 7b: P-R and $\bar{\textrm{P}}$-R curves calculated upon the STARE dataset with its original and an altered skew.');
    xlabel('Recall ($R$)');
    ylabel('Precision ($P$ and $\bar{P}$)');


    % Calculate the P-R curves using the original dataset
    %[p_STARE1, r_STARE1] = pr_curve(uint8(STARE_d1(:)), uint8(STARE_gt1(:)), 1);
    %figure(h1), plot(r_STARE1, p_STARE1, '--r')
    %drawnow
    
    % Calculate the P-R curves using the dataset with an altered skew
    %[p_STARE2, r_STARE2] = pr_curve(uint8(STARE_d2(:)), uint8(STARE_gt2(:)), 1);
    %figure(h1), plot(r_STARE2, p_STARE2, '--b')
    %drawnow
    
    
    % Calculate the iP-R curves using the original dataset
    [ip_STARE1, ir_STARE1] = ipr_curve(uint8(STARE_d1(:)), uint8(STARE_gt1(:)), interpolate, pi_1, pi_2);
    figure(h1), plot(ir_STARE1, ip_STARE1, 'r')
    drawnow
    
    % Calculate the P-R curves using the dataset with an altered skew
    [ip_STARE2, ir_STARE2] = ipr_curve(uint8(STARE_d2(:)), uint8(STARE_gt2(:)), interpolate, pi_1, pi_2);
    figure(h1), plot(ir_STARE2, ip_STARE2, 'b')
    
    
    
    legend({['P-R: $\pi =  ' num2str(sum(sum(STARE_gt1>0))/numel(STARE_gt1)) '$'], ...
            ['P-R: $\pi =  ' num2str(sum(sum(STARE_gt2>0))/numel(STARE_gt2)) '$'], ...
            ['$\bar{P}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$'], ...
            ['$\bar{P}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$']}, ...
            'Location', 'SouthWest');
    hold off

catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);
    
    rethrow(e);
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);

end