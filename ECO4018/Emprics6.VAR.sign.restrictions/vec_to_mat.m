function M = vec_to_mat(theta,p,m,c,rc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Joonyoung Hur
%           Department of Economics
%	        Indiana University
%
%   Format: M = vec_to_mat(theta,p,m,c,rc)
%   Function: vector to matrix
%
%   Note: theta must be a column vector
%
%   Input: column vector 'theta'
%          VAR order 'p'
%          # of variables 'm'
%          presence of trend components 'c'
%          M to be stacked column or raw 'rc'
%
%   Output: if rc=1, (m x ml) matrix of coefficients
%           elseif rc=2, (ml x m) matrix of coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if c == 1
%     np = (m*p+1);
% elseif c == 0
%     np = (m*p);
% end

np = m*p + c;

if rc==1
    theta = theta'; %% if stacking columns 
    for i=1:m
        M(i,:) = theta((i-1)*np+1:i*np);
    end
elseif rc==2
    for i=1:m
        M(:,i) = theta((i-1)*np+1:i*np);
    end
end 