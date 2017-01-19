function q = mrp2q(p, f)

% MRP2Q  Modified Rodrigues parameters to rotation quaternion
% 
% Convert modified Rodrigues parameters to corresponding rotation
% quaternion.
%
%   q = MRP2Q(p)    % for traditional MRPs
%   q = MRP2Q(p, f) % for scaled MRPs
%
% Inputs:
%
% p  Modified Rodrigues parameters (3-by-n)
% f  Optional scaling parameter (default 1)
%
% Outputs:
% 
% q  Rotation quaternion(s) (4-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults for the standard MRPs.
    if nargin < 2 || isempty(f), f = 1; end;

    % Check dimensions.
    assert(nargin >= 1, ...
           '%s: At least one input is required.', mfilename);
    assert(size(p, 1) == 3, ...
           '%s: The MRPs must be 3-by-n.', mfilename);
    assert(all(size(f) == 1) && f > 0, ...
           '%s: The scaling factor must be a positive scalar.', mfilename);
    
    n       = size(p, 2);
    q       = zeros(4, n, class(p));
    f2      = f * f;
    pm2     = p(1,:).*p(1,:) + p(2,:).*p(2,:) + p(3,:).*p(3,:);
    c0      = 1  ./ (f2 + pm2);
    q(4,:)  = c0 .* (f2 - pm2);
    c0      = (2*f) * c0;
    q(1,:)  = c0 .* p(1,:);
    q(2,:)  = c0 .* p(2,:);
    q(3,:)  = c0 .* p(3,:);
    
end % mrp2q
