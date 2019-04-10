function param = FitRetino(RX,RY)

 a0 = [3 1.8 1.4 0];
 LB = [1 1 1 -90];
 UB = [100 20 20 90];
 param=bads(@(param) cost_fun(param,RX,RY),a0,LB,UB) ;

end

function d = cost_fun(param,RX,RY)
   
   Rot = param(4);
   % rotate measured retinotopy
   RXr = imrotate(RX,Rot,'crop') ; 
   RYr = imrotate(RY,Rot,'crop') ; 
   
   RXr = abs(imresize(RXr,[50 50]));
   RYr = abs(imresize(RYr,[50 50]));
   
   RXr(isnan(RXr)) = [];
   RYr(isnan(RXr)) = [];
   % Set param in retino model
   R = RetinoEllipse; % create object
   R.u = RXr; % linspace(-5,-0.1,100);
   R.v = RYr;
   R.A  = param(1); 
   R.Bx = param(2); 
   R.By = param(3);
   R.cartesianVisual_to_cortical;
  
   % Calculate error (Least mean squares error)
    d = nansum( (RXr - R.x(:)).^2  +  (RYr - R.y(:)).^2 )^2 ;
  

end