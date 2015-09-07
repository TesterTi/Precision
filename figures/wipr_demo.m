function wipr_demo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plots figure 8b of the paper but instead of using the integrated
% precision measure uses the weighted integrated precision measure with the 
% skew weights Gaussianly distributed, such that:
%
%  w_function = @(pi')((1 / (pi_m * sqrt(2*pi)) * exp(-(pi' - pi_m)^2/(2 * pi_s^2)));
%
% where pi_m = 0.129 and pi_s = 0.035 (See section 4.1 of the paper). This 
% figure is not present in the paper and is included for demonstration
% purposes.
%
%
% The weighted integrated precision measure is detailed in Section 3.3.2 
% and its use in Section 4.1 of the paper:
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


% Define the anonymous function describing skew's weighting (Gaussian in
% this example)
pi_m = 0.129;
pi_s = 0.035;
w_function = @(pi_i)((1 / (pi_s .* sqrt(2*pi))) .* exp(-(((pi_i - pi_m).^2)./(2 * (pi_s.^2)))));

pi_1 = 0.0;       % Use this range for Gaussian weighting
pi_2 = 1.0;


% Exponential weighting
%w_function = @(pi_i)(log(10*pi_i)+1.5);

% Equivalent to Langrebe et al.'s measure
%w_function = @(pi_i)(1/(pi^2));

%pi_1 = 0.023;    % Use this range for exponential 
%pi_2 = 0.235;    % and Labdgrebe et al.'s weighting 
                  % (found in Section 4.1)


interpolate = 1;  % Smoother curve but slow


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
    title('Weighted $\bar{\textrm{P}}$-R curves calculated upon the STARE dataset, where $w(\pi'') = \frac{1}{\pi_m \sqrt{2 \pi}} e^{-\frac{(\pi''-\bar{\pi})^2}{2\hat{\pi}^2}}$');
    xlabel('Recall ($R$)');
    ylabel('Weighted Precision ($\bar{P}$)');
    
    h2 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Weighted $\bar{\textrm{P}}$-R Curve of a Random Classifier, where $w(\pi'') = \frac{1}{\pi_m \sqrt{2 \pi}} e^{-\frac{(\pi''-\bar{\pi})^2}{2\hat{\pi}^2}}$');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Weighted Precision ($\bar{P}$)');
    drawnow
    
    h3 = figure;
    axis square
    hold on
    axis([0 1 0 1]);
    title('Unachievable area of Weighted $\bar{\textrm{P}}$-R Space, where $w(\pi'') = \frac{1}{\pi_m \sqrt{2 \pi}} e^{-\frac{(\pi''-\bar{\pi})^2}{2\hat{\pi}^2}}$');
    axis([0 1 0 1]);
    xlabel('Recall ($R$)');
    ylabel('Weighted Precision ($\bar{P}$)');
    drawnow


    % Calculate the weighted iP-R curves using the original dataset
    [wip_STARE1, wir_STARE1] = wipr_curve(uint8(STARE_d1(:)), uint8(STARE_gt1(:)), interpolate, pi_1, pi_2, w_function);
    figure(h1), plot(wir_STARE1, wip_STARE1, 'r')
    drawnow
    
    % Calculate the weighted iP-R curves using the original dataset
    [wip_STARE2, wir_STARE2] = wipr_curve(uint8(STARE_d1(:)), uint8(STARE_gt2(:)), interpolate, pi_1, pi_2, w_function);
    figure(h1), plot(wir_STARE2, wip_STARE2, 'b')
    drawnow
    
    % Calculate the weighted iP-R curve for a random classifier
    [p, r] = wipr_random_classifier(pi_1, pi_2, w_function);
    figure(h2), plot(r, p);
    drawnow
    
    % Calculate the unachievable area of iP-R space
    [p, r] = wipr_unachievable(pi_1, pi_2, w_function);
    figure(h3), plot(r, p);
    drawnow
    
    
    figure(h1)
    legend({['w$\bar{P}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$'], ...
            ['w$\bar{P}$-R: $\pi_1 = ' num2str(pi_1) '$, $\pi_2 = ' num2str(pi_2) '$']}, ...
            'Location', 'SouthWest');
    hold off

catch e
    
    set(0, 'DefaultTextInterpreter', default_interpreter);
    
    rethrow(e);
    
end

set(0, 'DefaultTextInterpreter', default_interpreter);

end