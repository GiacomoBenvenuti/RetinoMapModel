function param = FitRetino(RX,RY)

a0 = [28.3848  300.0000  331.4604  -38.3694   -6.0992   51.8002];

LB = [   1     1     1  -60  -20 -20];

UB = [500 500 500 60 100 100];

param=bads(@(param) cost_fun(param,RX,RY),a0,LB,UB) ;



end

function d = cost_fun(param,RX,RY)

RXr = abs(imresize(RX,[50 50]));
RYr = abs(imresize(RY,[50 50]));

[X Y] =  find(~isnan(RXr));

% Set param in retino model
R = RetinoEllipse; % create object
R.u = RXr(~isnan(RXr)); % linspace(-5,-0.1,100);
R.v = RYr(~isnan(RYr));
R.A  = param(1);
R.Bx = param(2);
R.By = param(3);
R.Angle = param(4);
R.U0  = param(5);
R.V0 = param(6);
R.cartesianVisual_to_cortical;

% Calculate error (Least mean squares error)
d = nansum( (X - R.x(:)).^2  +  (Y - R.y(:)).^2 ) ;


end
