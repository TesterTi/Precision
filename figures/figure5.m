function figure5


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recreates figure 5 (b and c) of the paper:
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

 
simulate = 1;        % Simulate the class skew by transforming the P-R 
                     % curve using Eq. (3) or throw away instances from the
                     % dataset to create the class skew
                     % 1 = simulate, 0 = create

interpolate = 1;     % Smoother curve but is slow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



default_interpreter = get(0, 'DefaultTextInterpreter');
set(0,'DefaultTextInterpreter', 'LaTex');

try
    
    % Add the folder in which the functions are located to the path list
    path(path, '../toolbox');

    h3 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Figure 5a: Original P-R Curves (GT $\ge 1$)');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($P$)');
    drawnow
    
    h1 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Figure 5b: P-R Curves ($\pi = 0.01$)');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($P$)');
    drawnow

    h2 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Figure 5c: P-R Curves ($\pi = 0.5$)');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Precision ($P$)');
    drawnow
    
    
    gt = imread('../detector_responses/gt.tif');
    gt(gt > 0) = 1;
    gt = logical(gt);
    skew = sum(sum(gt > 0)) / numel(gt);

    % C-S Detection
    cs_response = imread('../detector_responses/cs_response.tif');
    % Gauss Detection
    ga_response = imread('../detector_responses/gauss_response.tif');
    
    
    % Plot the original curves
    
    [p, r] = pr_curve(cs_response(:), gt(:), interpolate);
    figure(h3), plot(r, p, 'b');
    hold on;
    [p, r] = pr_curve(ga_response(:), gt(:), interpolate);
    figure(h3), plot(r, p, 'r');
    hold off;
    drawnow
    
    
    % First test for skewed case (pi = 0.01)

    if simulate
        
        % Use the skew transform defined in Equation (3)
        [p, r] = pr_curve(cs_response(:), gt(:), interpolate);
        [p] = p_skew_transform(p, skew, 0.01);
        
    else
        
        % OR throw away positive examples to create the class skew
        [cs_response_0_01, gt_0_01] = adjust_skew(cs_response(:), gt(:), [0 1], 0.01);
        [p, r] = pr_curve(cs_response_0_01, gt_0_01, 1);
        
    end
    
    
    auc_0_01(1) = auc(p, r);

    figure(h1), plot(r, p, 'b');
    hold on;
    
    
    if simulate
        
        % Use the skew transform defined in Equation (3)
        [p, r] = pr_curve(ga_response(:), gt(:), interpolate);
        [p] = p_skew_transform(p, skew, 0.01);
        
    else
        
        % OR throw away positive examples to create the class skew
        [ga_response_0_01, gt_0_01] = adjust_skew(ga_response(:), gt(:), [0 1], 0.01);
        [p, r] = pr_curve(ga_response_0_01, gt_0_01, interpolate);
        
    end
    
    auc_0_01(2) = auc(p, r);

    figure(h1), plot(r, p, 'r');
    legend({['C-S: ' num2str(auc_0_01(1))], ['Gauss: ' num2str(auc_0_01(2))]});
    hold off;

    drawnow
    
    
    
    
    % Secondly test for balanced case (pi = 0.5)
    
    if simulate
        
        % Use the skew transform defined in Equation (3)
        [p, r] = pr_curve(cs_response(:), gt(:), interpolate);
        [p] = p_skew_transform(p, skew, 0.5);
        
    else
        
        % OR throw away negative examples to even the class balance
        [cs_response_0_5, gt_0_5] = adjust_skew(cs_response(:), gt(:), [0 1], 0.5);
        [p, r] = pr_curve(cs_response_0_5, gt_0_5, interpolate);
        
    end
    
    auc_0_5(1) = auc(p, r);

    figure(h2), plot(r, p, 'b');
    hold on;

    
    if simulate
        
        % Use the skew transform defined in Equation (3)
        [p, r] = pr_curve(ga_response(:), gt(:), interpolate);
        [p] = p_skew_transform(p, skew, 0.5);
        
    else
        
        % OR throw away negative examples to even the class balance
        [ga_response_0_5, gt_0_5] = adjust_skew(ga_response(:), gt(:), [0 1], 0.5);
        [p, r] = pr_curve(ga_response_0_5, gt_0_5, interpolate);
        
    end
    
    auc_0_5(2) = auc(p, r);

    figure(h2), plot(r, p, 'r');
    legend({['C-S: ' num2str(auc_0_5(1))], ['Gauss: ' num2str(auc_0_5(2))]});
    hold off;

    drawnow

catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);

    rethrow(e)
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);


end