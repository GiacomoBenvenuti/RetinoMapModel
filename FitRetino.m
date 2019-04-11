function param = FitRetino(RX,RY)

a0 = [20  2 3 0  0 0];

LB = [   1     1     1  -90  -100 -100];

UB = [500 3000 100000 90 100 100];

param=bads(@(param) cost_fun(param,RX,RY),a0,LB,UB) ;



end

function d = cost_fun(param,RX,RY)

[h w] = size(RX) ;

% Take a sample of equally spaced pixels values
 q = round(linspace(1,h,100));
 k =round(linspace(1,w,100));
 
 [X,Y] = meshgrid(round(linspace(1,h,100)),round(linspace(1,w,100)));
 RXs = RX(q,k);
 RYs = RY(q,k);
 X = X(~isnan(RXs)) ;
 Y = Y(~isnan(RYs) );
 RXs = RXs(~isnan(RXs)) ;
 RYs = RYs(~isnan(RYs) );
 
 
[x y] = RetinoModel(RXs,RYs,param);

% Calculate error (Least mean squares error)
d = nansum( (X - x).^2  +  (Y - y).^2 ) ;


end
