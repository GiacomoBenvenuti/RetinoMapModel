load ./testdata/testdata.mat
figure
subplot(121)
imagesc(RetinotopyCartesianXValid); axis square

subplot(122)
imagesc(RetinotopyCartesianYValid); axis square
%%
RX = RetinotopyCartesianXValid;
RY= RetinotopyCartesianYValid;



%%
addpath ../bads
param= FitRetino(RX,RY)


RXr = abs(imresize(RX,[50 50]));
RYr = abs(imresize(RY,[50 50]));


[X Y] =  find(~isnan(RXr));

% Set param in retino model
R = RetinoEllipse; % create object
R.u = RXr(:); % linspace(-5,-0.1,100);
R.v = RYr(:);
R.A  = param(1);
R.Bx = param(2);
R.By = param(3);
R.Angle = param(4);
R.U0  = param(5);
R.V0 = param(6);
R.cartesianVisual_to_cortical;

%%
figure
subplot(221)
scatter(R.x,R.y,60,R.u,'filled'); colorbar; grid
% xlim([0 50])
% ylim([0 50])
hold on 
scatter(param(5),param(6),100,'+')

subplot(222)
scatter(X,Y,60,RXr(~isnan(RXr)),'filled'); colorbar; grid
%set(gca,'YDir','normal'); colorbar
xlim([0 50])
ylim([0 50])

subplot(223)
scatter(R.x,R.y,60,R.v,'filled'); colorbar; grid
xlim([0 50])
ylim([0 50])

subplot(224)
scatter(X,Y,60,RYr(~isnan(RYr)),'filled'); colorbar; grid
%  set(gca,'YDir','normal'); colorbar
xlim([0 50])
ylim([0 50])


%%
[U V] = meshgrid(linspace(-4,-.1,10),linspace(-2,-.1,10));
%[U V] = meshgrid(linspace(1,5,10),linspace(-1,5,10));
M = RetinoEllipse(U,V); 
M.A  = param(1);
M.Bx = param(2);
M.By = param(3);
M.Angle = param(4);
M.U0  = param(5);
M.V0 = param(6);
M.cartesianVisual_to_cortical;
figure
M.disp