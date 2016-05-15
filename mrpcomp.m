function p = mrpcomp(pb, pa, f)

% MRPCOMP  Modified Rodrigues parameter composition
%
% Calculate the MRPs corresponding to a rotation of MRPs pa followed by pb.
% In this manner, it has the same order as direction cosine matrix
% multiplication and rotation quaternion composition.
%
%   p = MRPCOMP(pb, pa)    % for traditional MRPs
%   p = MRPCOMP(pb, pa, f) % for scaled MRPs
%
% Inputs:
%
% pb  Modified Rodrigues parameters for second rotation (3-by-n)
% pa  Modified Rodrigues parameters for first rotation (3-by-n)
% f   Optional scaling parameter (default 1)
%
% Outputs:
%
% p  Modified Rodrigues parameters of  resulting rotation (3-by-n)

% Copyright 2016 An Uncommon Lab

%#codegen

    % Set defaults so that for small angles, the scaled MRPs approach the
    % rotation vector.
    if nargin < 3 || isempty(f), f = 1; end;

    % Check dimensions.
    assert(nargin >= 2, ...
           '%s: At least two inputs are required.', mfilename);
    assert(size(pb, 1) == 3 && size(pa, 1) == 3, ...
           '%s: The MRPs must be 3-by-n.', mfilename);
    assert(size(pb, 2) == size(pa, 2), ...
           '%s: The number of MRPs in each input must match.', mfilename);
    assert(all(size(f) == 1) && f > 0, ...
           '%s: The scaling factor must be a positive scalar.', mfilename);

    % If in MATLAB, vectorize.
    if isempty(coder.target)
        
        f2 = f * f;
        p1m2 = pa(1,:).*pa(1,:) + pa(2,:).*pa(2,:) + pa(3,:).*pa(3,:);
        p2m2 = pb(1,:).*pb(1,:) + pb(2,:).*pb(2,:) + pb(3,:).*pb(3,:);
        d    = pa(1,:).*pb(1,:) + pa(2,:).*pb(2,:) + pa(3,:).*pb(3,:);
        c0   = (f2 - p1m2);
        c1   = (f2 - p2m2);
        c2   = 1./(f2 + (1/f2) .* p1m2 .* p2m2 - 2 * d);
        p    = (-2*f) * cross3(pb, pa);
        p(1,:) = (p(1,:) + c0 .* pb(1,:) + c1 .* pa(1,:)) .* c2;
        p(2,:) = (p(2,:) + c0 .* pb(2,:) + c1 .* pa(2,:)) .* c2;
        p(3,:) = (p(3,:) + c0 .* pb(3,:) + c1 .* pa(3,:)) .* c2;
        
    % Otherwise, make good C.
    else
        
        n  = size(pa, 2);
        p  = zeros(3, n, class(pa));
        f2 = f * f;
        for k = 1:n
            p1m2 = pa(1,k).*pa(1,k) + pa(2,k).*pa(2,k) + pa(3,k).*pa(3,k);
            p2m2 = pb(1,k).*pb(1,k) + pb(2,k).*pb(2,k) + pb(3,k).*pb(3,k);
            d    = pa(1,k).*pb(1,k) + pa(2,k).*pb(2,k) + pa(3,k).*pb(3,k);
            p(:,k) =   (f2 - p1m2) * pb(:,k) ...
                     + (f2 - p2m2) * pa(:,k) ...
                     - 2*f * cross3(pb(:,k), pa(:,k));
            p(:,k) = (1/(f2 + p1m2 * p2m2 / f2 - 2 * d)) * p(:,k);
        end
        
    end
    
end % mrpcomp
