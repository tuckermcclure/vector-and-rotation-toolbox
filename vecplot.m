function h = vecplot(varargin)

% VECPLOT  Plot a 3-by-n vector without breaking it up
%
% This is a convenience function that allows one to plot a 3-by-n set of
% vectors without manually breaking it up into x, y, and z components
% (which is tedious when one works with vectors frequently).
% 
%    h = vecplot(v, ...);    % New plot3 with vector data
%    h = vecplot(f, v, ...); % New plot using plotting function f
%    h = vecplot(h, v, ...); % Updates plot h
%
% Any additional arguments are passed along to the plot function.
% 
% This replaces all of the following forms:
%
%    h = plot3(v(1,:), v(2,:), v(3,:), ...);
%    set(h, 'XData', v(1,:), 'YData', v(2,:), 'ZData', v(3,:), ...);
%
% Inputs:
%
% v  Set of vectors (3-by-n)
% f  Plotting function to use (default is @plot3)
% h  Handle(s) of plot(s) to update (1-by-m)
%
% Outputs:
%
% h  Handle(s) new/updated plot(s) (1-by-m)
% 
% Example:
%
% Let's make a red, dotted plot.
% 
% xyz = rand(3, 10);
% h = vecplot(xyz, 'r:');
%
% Let's update the plot.
% 
% xyz2 = [xyz rand(3, 1)];
% vecplot(h, xyz2);
%
% Example: Specifying Plot Type
%
% Let's create a 3D scatter plot from vector data using the data from
% above.
% 
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
        
        for k = 1:length(h)
            set(h(k), 'XData', v(1,:), ...
                      'YData', v(2,:), ...
                      'ZData', v(3,:), ...
                      args{:});
        end
        
    end
    
end % vecplot
