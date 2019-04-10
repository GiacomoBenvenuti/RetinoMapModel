p = FitRetino(RetinotopyCartesianXValid,RetinotopyCartesianYValid);

%%

   R = RetinoEllipse; % create object
   R.u = linspace(-5,0,100);
   R.v = linspace(-5,0,100);
   R.A  = p(1); 
   R.Bx = p(2); 
   R.By = p(3);
   R.cartesianVisual_to_cortical;
   
   %%
   figure
   subplot(221)
  
   imagesc(R.x); colorbar
   
   subplot(222)
   SX = imrotate(RetinotopyCartesianXValid,p(4),'crop') ; 
   imagesc(SX); colorbar
   
    subplot(223)
  
   imagesc(R.y); colorbar
   
   subplot(224)
   SX = imrotate(RetinotopyCartesianYValid,p(4),'crop') ; 
   imagesc(SX); colorbar
   
  