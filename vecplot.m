function h = vecplot(varargin)

% function h = vecplot(v, varargin)
% 
%    h = vecplot(v);    % New plot3 with vector data
%    h = vecplot(f, v); % New plot using f
%    h = vecplot(h, v); % Updates plot h
% 
% This function provides a simple mask for plotting 3D vectors. It accepts 
% 3-by-n data and plots the n points in 3D space. By default, it uses
% plot3, but can also use scatter3 or bar3 on request (see examples). It 
% returns a handle to the plot. Any additional arguments are passed to the 
% plotting function directly.
%
% % Example:
%
% % Let's make a red, dotted plot.
% xyz = rand(3, 10);
% h = vecplot(xyz, 'r:');
%
% % Let's update the plot.
% xyz2 = [xyz rand(3, 1)];
% vecplot(h, xyz2);
%
% % Example: Specifying Plot Type
%
% % Let's create a 3D scatter plot from vector data using the data from
% % above.
% h = vecplot(@scatter3, xyz);
% 

% Copyright 2016 An Uncommon Lab

    % Figure out the inputs.
    f = @plot3;
    h = [];
    if isa(varargin{1}, 'function_handle')
        f = varargin{1};
        v    = varargin{2};
        args = varargin(3:end);
    elseif ishandle(varargin{1})
        h = varargin{1};
        v    = varargin{2};
        args = varargin(3:end);
    else
        v = varargin{1};
        args = varargin(2:end);
    end
    
    % Check dimensions (and transpose if necessary).
    if size(v, 1) ~= 3
        if size(v, 2) == 3
            v = v.';
        else
            error('Input to %s should be a 3-by-n vector.', mfilename());
        end
    end

    % If new plot...
    if isempty(h)
        
        h = f(v(1,:), v(2,:), v(3,:), args{:});
        
    % Otherwise, updating existing plot...
    else
        
        set(h, 'XData', v(1,:), 'YData', v(2,:), 'ZData', v(3,:), args{:});
        
    end
    
end % vecplot
