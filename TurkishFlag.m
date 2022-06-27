% Turkish Flag
% 
% A: Distance from the left midpoint of the flag to the center of
%    outer crescent's center
% B: Diameter of the star's outer circle
% C: Distance between the crescent's inner and outer circles
% D: Diameter of the inner circle of the crescent
% E: Distance from the leftmost point of the inner circle of the crescent
%    to the leftmost point of the circle around the star
% F: Diameter of the outer circle of the crescent
% G: Width of the flag
% L: Length of the flag
% M: Width of the white stripe at the hoist

% Definition of parameters

G   = 100;
A   = .5      * G;
B   = .25     * G;
C   = (1/16)  * G;
D   = .4      * G;
E   = (1/3)   * G;
F   = .5      * G;
L   = 1.5     * G;
M   = (1/30)  * G;

% Precision

p = 200;
% Note: Precision is used to obtain a smooth crescent

% Definition of Colors

red     = [227, 10, 23]/255;
white   = [255, 255, 255]/255;


% Star Patch Parameters

edges   = linspace(pi, -pi+2*pi/5, 5);      % 5 edges as angles in polar coordinates
xsouter = B/2 * cos(edges);                 % x values of outward points in cartesian coordinates
ysouter = B/2 * sin(edges);                 % y values of outward points in cartesian coordinates
xsinner = zeros(1, 5);
ysinner = zeros(1, 5);

tx      = repmat(xsouter, 1, 2);            % Temporary matrices
ty      = repmat(ysouter, 1, 2);            % Temporary matrices

for i = 1 : 5
    [xsinner(i), ysinner(i)] = polyxpoly([tx(i),   tx(i+2)],...
                                         [ty(i),   ty(i+2)],...
                                         [tx(i+1), tx(i+4)],...
                                         [ty(i+1), ty(i+4)]);
end
% Note: The for loop above finds intersection points between outward point
%   couples. Every loop finds the intersection of lines:
%   1. Lying along a point and the second next point,
%   2. Lying along through the previous point (4th next) and the next point.

% Crescent Patch Variables

% Solving for intersection point of two circles
syms y(x)
xinter  = double(solve(sqrt(-x.^2+(F/2)^2)==sqrt(-(x-C).^2+(D/2)^2)));
yinter  = sqrt(-xinter^2+(F/2)^2);
clear y x

% x coordinates of circles
xcouter = [linspace(xinter, -F/2, p), linspace(-F/2, xinter, p)];

xcinner = [linspace(xinter, -D/2+C, p), linspace(-D/2+C, xinter, p)];

% y coordinates of circles
ycouter = [-sqrt((F/2)^2-linspace(xinter, -F/2, p).^2),...
            sqrt((F/2)^2-linspace(-F/2, xinter, p).^2)];
        
ycinner = [sqrt((D/2)^2-(linspace(xinter, -D/2+C, p)-C).^2),...
           -sqrt((D/2)^2-(linspace(-D/2+C, xinter, p)-C).^2)];

       
% Background, stripe and concatenation

patch([0, M+L, M+L, 0], [-G/2, -G/2, G/2, G/2], red, 'EdgeColor', red);

m       = patch([0, M, M, 0], [-G/2, -G/2, G/2, G/2], white);
c       = patch(A+M+[xcouter,xcinner], real([ycouter,ycinner]), white, 'EdgeColor', white);
s       = patch(E+A+C+M-D/2+B/2+reshape([xsouter; xsinner], 1, []),...
                reshape([ysouter; ysinner], 1, []),...
                white, 'EdgeColor', white);

% Expanding figure for a better view
xlim([-L/10, 1.1*L])
ylim([-.75*G, .75*G])
