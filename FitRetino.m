function param = FitRetino(RX,RY)

a0 = [   3   500  500     30       0       0  ];

LB = [   0  300  300       -90   -500 -500];

UB = [ 30 2000 2000 90 1000 1000];

param=bads(@(param) cost_fun(param,RX,RY),a0,LB,UB) ;



end

function d = cost_fun(param,RX,RY)
N = 20;

[h w] = size(RX) ;

% Take a sample of equally spaced pixels values
 q = round(linspace(1,h,N));
 k =round(linspace(1,w,N));

 [X,Y] = meshgrid(q,k) ;
 RXs = RX(q,k) ;
 RYs = RY(q,k) ;
 X = X(~isnan(RXs)) ;
 Y = Y(~isnan(RYs) );
 RXs = RXs(~isnan(RXs)) ;
 RYs = RYs(~isnan(RYs) );
 
 
[x y] = RetinoModel(RXs,RYs,param);

% Calculate error (Least mean squares error)

%d = nansum( sqrt((X  - x).^2  +  (Y  - y).^2 )) ;
d = nansum( ((X - x).^2  +  (Y  - y).^2 )) ;

end
