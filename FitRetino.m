function param = FitRetino(RX,RY)
% param = FitRetino(RX,RY)
%
%-------------------------------------------
% by Giacomo Benvenuti & Wahiba Taouali
% <giacomox@gmail.com>
% Repository
% https://github.com/giacomox/RetinoMapModel
%-------------------------------------------

% Initial param
a0 = [  5.0000  500.0488  3000.0000   60.0000  600.0000 -150.0000 ];
% Param Lower Bound
LB = [  .1  300   300    -90   -200   -200];
% Param Upper Bound
UB = [ 30   5000  5000   90    1000   1000];

param=bads(@(param) cost_fun(param,RX,RY),a0,LB,UB) ;

end

function d = cost_fun(param,RX,RY)

% Downsample the data
N = 20;
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


[x y] = RetinoModel(RXs,RYs,param);

% Calculate Least mean squares error
d = nansum(   ((X - x).^2  +  (Y - y).^2 )   ) ;
%d = nansum( (X - x).^2 )  +  nansum( (Y - y).^2 )   ;

end
