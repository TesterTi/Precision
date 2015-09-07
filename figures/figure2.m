function figure2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recreates figure 2a and 2b (plus figure 6e and 6f) of the paper:
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
    hold on
    axis([0 1 0 1]);
    title('Figure 2a: Single Scale Gaussian ROC Curves');
    axis([0 1 0 1]);
    xlabel('False Positive Rate (FPR)');
    ylabel('True Positive Rate (TPR or R)');
    drawnow

    h2 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Figure 2b: Centre-Surround ROC Curves');
    axis([0 1 0 1]);
    xlabel('False Positive Rate (FPR)');
    ylabel('True Positive Rate (TPR or R)');
    drawnow
    
    
    gt = imread('../detector_responses/gt.tif');
    
    cc = jet(double(max(max(gt))));
    
    
    cs_response = imread('../detector_responses/cs_response.tif');
    ga_response = imread('../detector_responses/gauss_response.tif');
    
    
    for i = 1:max(max(gt))
    
        gt_cur = gt;
        gt_cur(gt_cur < i) = 0;
        gt_cur(gt_cur > 0) = 1;


        [tpr, fpr] = roc_curve(ga_response(:), gt_cur(:), 0);

        figure(h1), plot(fpr, tpr, 'color', cc(i,:));
        drawnow


        [tpr, fpr] = roc_curve(cs_response(:), gt_cur(:), 0);

        figure(h2), plot(fpr, tpr, 'color', cc(i,:));
        drawnow
    
    end
    
    figure(h1)
    legend({'$\ge 1$','$\ge 2$','$\ge 3$','$\ge 4$','$\ge 5$','$\ge 6$',...
        '$\ge 7$','$\ge 8$','$\ge 9$','$\ge 10$','$\ge 11$','$\ge 12$',...
        '$\ge 13$'}, 'Location', 'SouthEast');
    hold off;
    figure(h2)
    legend({'$\ge 1$','$\ge 2$','$\ge 3$','$\ge 4$','$\ge 5$','$\ge 6$',...
        '$\ge 7$','$\ge 8$','$\ge 9$','$\ge 10$','$\ge 11$','$\ge 12$',...
        '$\ge 13$'}, 'Location', 'SouthEast');
    hold off;

catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);

    rethrow(e)
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);


end