function l = hLine(l)
% Draws a line on current figure, using as argument a 2D line given in homogeneous coordinates.

% Draw the line l
fig = figure(gcf);
fig_axes = get(fig,'CurrentAxes');
x_lim = get(fig_axes,'XLim');
y_lim = get(fig_axes,'YLim');
%Error if no direction
if(l(1)==0 && l(2)==0) 
    error('Line has no direction!'); 
    return;
end
%warning('line: %d , %d , %d',l(1),l(2),l(3));
%If vertical line within limits
if(l(2)==0)
    x_c = -l(3)/l(1);
    if(x_c<x_lim(1) || x_c>x_lim(2)) % outside
        warning('Line outside: %d , %d , %d',l(1),l(2),l(3));
       return;
    end
    line([x_c x_c],[y_lim(1) y_lim(2)]);
    return;
end
%If horizontal line within limits
if(l(1)==0)
    y_c = -l(3)/l(2);
    if(y_c<y_lim(1) || y_c>y_lim(2)) % outside
        warning('Line outside: %d , %d , %d',l(1),l(2),l(3));
       return;
    end    
    line([x_lim(1) x_lim(2)],[y_c y_c]);
    return;
end
y_min = - (l(1)*x_lim(1)+l(3))/l(2);
y_max = - (l(1)*x_lim(2)+l(3))/l(2);
x_min = x_lim(1);
x_max = x_lim(2);
line([x_min x_max],[y_min y_max]);
