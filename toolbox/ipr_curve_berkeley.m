function [p, r, au, threshold_values] = ipr_curve_berkeley(response, gt, class_labels, interpolate, maxDist, pi1, pi2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [p, r, au, threshold_values] = ipr_curve_berkeley(response, gt, maxDist, interpolate, pi1, pi2)
%
% Calculate iPrecision/Recall curve using the Berkeley matching criteria.
%
% INPUT
%	response     : An N x M Detector response
%	gt           : Ground Truth image (also N x M)
%   class_labels : A 1 x 2 vector containing the class labels, i.e. [neg_label, pos_label]
%   maxDist      : For computing iPrecision / Recall (0.0075)
%   interpolate  : interpolate between iPR points (0 or 1)
%   pi1          : iPR integration limit
%   pi2          : iPR integration limit
%
% OUTPUT
%	p                : Precision
%	r                : Recall
%	au               : Area under the curve
%	threshold_values : Threshold values used to derive the iPR curve
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
number_of_data_points = 100;       % of the PR Curve


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if ~isscalar(pi1) || ~isfloat(pi1) || pi1 > 1 || pi1 < 0
    error('Pi 1 must be a floating point scalar between 0 and 1');
end

if ~isscalar(pi2) || ~isfloat(pi2) || pi2 > 1 || pi2 < 0
    error('Pi 2 must be a floating point scalar between 0 and 1');
end

if isvector(response)
    error('The algorithm''s response should be in the format of a N x M matrix, where N is the image height and M is its width.');
end

if isvector(gt)
    error('The gt should be in the format of a N x M matrix, where N is the image height and M is its width.');
end

if all(size(response) ~= size(gt))
    error('The detection and gt should be of the same size');
end

if isa(gt, 'uint8') || isa(gt, 'uint16') || isa(gt, 'uint32') || isa(gt, 'uint64')
    gt = int8(gt);
end


pos_label = class_labels(2);
neg_label = class_labels(1);
gt(gt == pos_label) = 1;
gt(gt == neg_label) = 0;



berkeley_path     = correct_path([fileparts(which('ipr_curve_berkeley')) filesep 'support_functions']);
path(path, berkeley_path);




threshold_values = linspace(double(min(min(response))), double(max(max(response))), number_of_data_points);

% zero all counts
p  = zeros(1, number_of_data_points);
tp = zeros(1, number_of_data_points);
fp = zeros(1, number_of_data_points);
tn = zeros(1, number_of_data_points);
fn = zeros(1, number_of_data_points);
cntR = zeros(size(threshold_values));
sumR = zeros(size(threshold_values));

for i = 1:numel(threshold_values)
    
    detection = zeros(size(response), 'int8');
    
    detection(response >= threshold_values(i)) = 1;
    
    % accumulate machine matches, since the machine pixels are
    % allowed to match with any segmentation
    accP = zeros(size(detection));
    
    % compare to each seg in turn
    for j = 1:size(gt, 3)
        
        curr_gt = gt(:,:,j);
        
        % compute the correspondence
        [match1, match2] = correspondPixels(double(detection), double(curr_gt), maxDist);
        
        % accumulate machine matches
        accP = accP | match1;
        
        % compute recall
        sumR(i) = sumR(i) + sum(curr_gt(:));
        cntR(i) = cntR(i) + sum(match2(:) > 0);
        
    end
    
    % compute iPrecision
    tp(i) = sum(accP(:));
    fp(i) = sum(detection(:)) - tp(i);
    tn(i) = sum(accP(:) == 0 & curr_gt(:) == 0);                           % !!!CHECK THAT TN IS CORRECT!!!
    fn(i) = sum(accP(:) > 0 & curr_gt(:) == 0);                            % !!!CHECK THAT FN IS CORRECT!!!
    
    phi = sum(gt(:) > 0) / sum(gt(:) == 0);                                % !!!NEED TO CHECK HOW TO CALCULATE DATASET SKEW!!!
    
    % compute the iPR point
    q = @(pi)((pi * tp(i)) ./ ((pi * tp(i)) + ((1-pi) * phi * fp(i)))); 
	p(i) = (1/(pi2-pi1))*integral(q, pi1, pi2); % Eq. (7)
    
	%[~, ~, p(i), ~, tp(i), fp(i), tn(i), fn(i)] = ipr_point(accP(:), curr_gt(:), pi1, pi2);
    
end

r = cntR ./ sumR;

% Interpolate along the curve if desired
if interpolate
    
    ps_n = [];
    rs_n = [];
    
    for j = 1:number_of_data_points-1
        
        [ps1, rs1] = ipr_interpolate(tp(j+1), tp(j), fp(j+1), fp(j), tn(j), fn(j), pi1, pi2);

        ps_n = [ps_n, p(j), ps1(end:-1:1)];
        rs_n = [rs_n, r(j), rs1(end:-1:1)];

    end
    
    p = ps_n;
    r = rs_n;
    
end



% Calculate the curve's AUC
au = auc(p(~isnan(p)), r(~isnan(p)));

end