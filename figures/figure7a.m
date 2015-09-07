function figure7a


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recreates figure 7a of the paper:
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


pi_1 = 0.0;       % Range used in the paper
pi_2 = 0.5;
 
interpolate = 1;  % Smoother curve but slow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



d1 = imread('../detector_responses/gauss_response.tif');
gt1 = imread('../detector_responses/gt.tif');
gt1(gt1 > 0) = 1;

% Alter the Skew (remove 50% of negative instances)
gt2 = gt1(:);
d2  = d1(:);
neg_ind = find(gt2 == 0);
pos_ind = find(gt2 > 0);
ind = randperm(numel(neg_ind));
neg_ind = neg_ind(ind(1:round(numel(ind)*0.5)));
gt2 = [gt2(neg_ind); gt2(pos_ind)];
d2 = [d2(neg_ind); d2(pos_ind)];


default_interpreter = get(0, 'DefaultTextInterpreter');
set(0,'DefaultTextInterpreter', 'LaTex');

try
    
    % Add the folder in which the functions are located to the path list
    path(path, '../toolbox');

    
    h1 = figure;
    axis square
    axis([0 1 0 1]);
    hold on
    title('Figure 7a: P-R and $\bar{\textrm{P}}$-R curves calculated upon the fissure image with its original and an altered skew.');
    xlabel('Recall ($R$)');
    ylabel('Precision ($P$ and $\bar{P}$)');


    % Calculate the P-R curves using the original dataset
    [p_FISSURE1, r_FISSURE1] = pr_curve(uint8(d1(:)), uint8(gt1(:)), interpolate);
    figure(h1), plot(r_FISSURE1, p_FISSURE1, '--r')
    drawnow
    
    % Calculate the P-R curves using the dataset with an altered skew
    [p_FISSURE2, r_FISSURE2] = pr_curve(uint8(d2(:)), uint8(gt2(:)), interpolate);
    figure(h1), plot(r_FISSURE2, p_FISSURE2, '--b')
    drawnow
    
    
    % Calculate the iP-R curves using the original dataset
    [ip_FISSURE1, ir_FISSURE1] = ipr_curve(uint8(d1(:)), uint8(gt1(:)), interpolate, pi_1, pi_2);
    figure(h1), plot(ir_FISSURE1, ip_FISSURE1, 'r')
    drawnow
    
    % Calculate the P-R curves using the dataset with an altered skew
    [ip_FISSURE2, ir_FISSURE2] = ipr_curve(uint8(d2(:)), uint8(gt2(:)), interpolate, pi_1, pi_2);
    figure(h1), plot(ir_FISSURE2, ip_FISSURE2, 'b')
    
    
    
    legend({['P-R: $\pi =  ' num2str(sum(sum(gt1>0))/numel(gt1)) '$'], ...
            ['P-R: $\pi =  ' num2str(sum(sum(gt2>0))/numel(gt2)) '$'], ...
            ['$\bar{\textrm{P}}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$'], ...
            ['$\bar{\textrm{P}}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$']}, ...
            'Location', 'SouthWest');
    hold off

catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);
    
    rethrow(e);
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);

end