function param = FitRetino(varargin)
% param = FitRetino(RX,RY) % Default initial param
% param = FitRetino(RX,RY,initial_param) % Custom initial param
% param = [ A, Bx, By, Angle, U0, V0 ]
%
%-------------------------------------------
% by Giacomo Benvenuti & Wahiba Taouali
% <giacomox@gmail.com>
% Repository
% https://github.com/giacomox/RetinoMapModel
%-------------------------------------------

RX = varargin{1};
RY = varargin{2};

A = 5;
%       R_scale   Scaling     R_spacingX  R_spacingY  R_angle  R_OffsetX  R_OffsetY 
% Initial param
a0 = [   .000001         5        1100         1100         0        19000       2400   ];
% Param Lower Bound
LB = [   .000001         3          300         300        -180       -200       -200   ];
% Param Upper Bound 
UB = [   .000001        10        10000        10000        180       30000      30000   ];

if nargin > 2
   a0 = varargin{3}; 
end

param=bads(@(param) cost_fun(param,RX,RY),a0,LB,UB) ;

end

function d = cost_fun(param,RX,RY)

% Downsample the data
N = 40;
[h w] = size(RX) ;

% Take a sample of equally spaced pixels values
q = round(linspace(1,h,N));
k = round(linspace(1,w,N));

[X,Y] = meshgrid(q,k) ;


RXs = RX(q,k) ;
RYs = RY(q,k) ;
X = X(~isnan(RXs)) ;
Y = Y(~isnan(RYs) );
RXs = RXs(~isnan(RXs)) ;
RYs = RYs(~isnan(RYs) );

[x y] = RetinoModel(RXs ,RYs , param);

% Calculate Least mean squares error
d = nansum(   ((X - x).^2  +  (Y - y).^2 )   ) ;
%d = nansum( (X - x).^2 )  +  nansum( (Y - y).^2 )   ;
%d = 1 - corr( pdist(cat(2,[X,Y]))', pdist(cat(2,[x,y]))' );
end
