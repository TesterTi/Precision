function figure6cd


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recreates figure 6 (c and d) of the paper:
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


lambda1 = 1;    % Range used in the paper
lambda2 = 100;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



default_interpreter = get(0, 'DefaultTextInterpreter');
set(0,'DefaultTextInterpreter', 'LaTex');

try
    
    % Add the folder in which the functions are located to the path list
    path(path, '../toolbox');
    path(path, './support_functions');
    
    h1 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Figure 7a: Single Scale Gaussian $\hat{\textrm{P}}$-R Curves using Landgrebe et al.''s Formulation, where $\lambda_1=1$ and $\lambda_2=100$');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($\hat{P}$)');
    drawnow

    h2 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Figure 7b: Centre-Surround $\hat{\textrm{P}}$-R Curves using Landgrebe et al.''s Formulation, where $\lambda_1=1$ and $\lambda_2=100$');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($\hat{P}$)');
    drawnow
    
    
    gt = imread('../detector_responses/gt.tif');
    
    cc = jet(double(max(max(gt))));
    
    
    cs_response = imread('../detector_responses/cs_response.tif');
    ga_response = imread('../detector_responses/gauss_response.tif');
    
    
    for i = 1:max(max(gt))
    
        gt_cur = gt;
        gt_cur(gt_cur < i) = 0;
        gt_cur(gt_cur > 0) = 1;


        [p, r] = landgrebe_ipr_curve(ga_response(:), gt_cur(:), lambda1, lambda2);
        
        figure(h1), plot(r, p, 'color', cc(i,:));
        drawnow


        [p, r] = landgrebe_ipr_curve(cs_response(:), gt_cur(:), lambda1, lambda2);

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

catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);

    rethrow(e)
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);


end