function [STARE_d, STARE_gt1, STARE_gt2] = load_STARE


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Loads STARE detections and GT. 
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


f = dir('../detector_responses/STARE/Results/');

STARE_d = [];
STARE_gt1 = [];
STARE_gt2 = [];

for i = 1:numel(f)
    if ~f(i).isdir
        if strcmpi(f(i).name(1:6), 'result')
            
            %img = imread(['../detector_responses/STARE/Images/im' f(i).name(7:10) '.tif']);
            
            % Load the detection (output of MLVessel v1.4, using the
            % supplied trained classifier for STARE
            % (mlvessel-optional-1.4.zip)
            % http://sourceforge.net/apps/mediawiki/retinal/index.php?title=Software
            det = imread(['../detector_responses/STARE/Results/' f(i).name]);
            
            % Adds noise to the detection
            ind = randperm(numel(det));
            ind = ind(1:round(numel(det)*0.10));
            noise = rand(1, numel(ind)) * 255;
            det(ind) = noise;
            
            % Load the GTs
            if exist(['../detector_responses/STARE/GTs/im' f(i).name(7:10) '.ah.ppm'], 'file') ~=2 || ...
                    exist(['../detector_responses/STARE/GTs/im' f(i).name(7:10) '.vk.ppm'], 'file') ~=2
                error('Both of the STARE dataset ground truths need to be downloaded from http://www.parl.clemson.edu/~ahoover/stare/probing/index.html and placed in the %toolboxroot%/detector_responses/STARE/GTs directory (see the readme for more information)');
            else
                gt1 = imread(['../detector_responses/STARE/GTs/im' f(i).name(7:10) '.ah.ppm']);
                gt2 = imread(['../detector_responses/STARE/GTs/im' f(i).name(7:10) '.vk.ppm']);
            end
            
            STARE_d  = [STARE_d; det(:)];
            STARE_gt1 = [STARE_gt1; gt1(:)];
            STARE_gt2 = [STARE_gt2; gt2(:)];
            
        end
    end
end