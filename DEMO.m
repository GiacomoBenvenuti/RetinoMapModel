%% DEMO Retinotopic Model 
% by Giacomo Benvenuti 2019
%--------------------------

%% Test model using a grid
[U V] = meshgrid(linspace(-4,4,10),linspace(-2,2,10));
%M = RetinoEllipse(U,V); 
%figure; M.disp
param = [3 2 2 0 0 0];
[x y] = RetinoModel(U,V,param,1)
%% Load measured retinotopic coordinates
% set RetinoEllipse as Current Folder
load ./testdata/testdata.mat
RX = RetinotopyCartesianXValid;
RY= RetinotopyCartesianYValid;

%% Display retinotopic coordinates

figure
subplot(121)
imagesc(RX); axis square
set(gca,'YDir','normal'); colorbar
xlabel('pixels'); ylabel('pixels')
title('X visual coordinates (cartesian)')

subplot(122)
imagesc(RY); axis square
set(gca,'YDir','normal'); colorbar
xlabel('pixels'); ylabel('pixels')
title('Y visual coordinates (cartesian)')
set(gcf,'color','w')

%saveas(gcf,'./figures/RealRetino','png')

%% Fit Real retino with retinotopic model
% add "bads" library to the Matlab path (minimization alghoritm
% similar to fminsearch)
% you can donwload bads here https://github.com/lacerbi/bads
%addpath ../bads
tic
param= FitRetino(RX,RY)
toc
save('./testdata/param','param')
%%
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

%
figure
subplot(221)
scatter(x,y,60,RXs,'filled'); colorbar; grid
xlim([0 500])
ylim([0 500])

subplot(222)
scatter(X,Y,60,RXs,'filled'); colorbar; grid
xlim([0 500])
ylim([0 500])



subplot(223)
scatter(x,y,60,RYs,'filled'); colorbar; grid
xlim([0 500])
ylim([0 500])

subplot(224)
scatter(X,Y,60,RYs,'filled'); colorbar; grid
%  set(gca,'YDir','normal'); colorbar
xlim([0 500])
ylim([0 500])


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