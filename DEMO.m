%% DEMO Retinotopic Model 
% by Giacomo Benvenuti 2019
%--------------------------

%% Test model using a grid
[U V] = meshgrid(linspace(-4,0,10),linspace(-2,0,10));

param1 = [3 1.8 1.2 0 0 0];

figure
[x y] = RetinoModel(U,V,param,1)
%% Load measured retinotopic coordinates
% set RetinoEllipse as Current Folder
load ./testdata/testdata.mat
RX = RetinotopyCartesianYValid; % corresponds to fix the "Y" coordinate
RY= RetinotopyCartesianXValid;

%% Display retinotopic coordinates

figure
subplot(221)
imagesc(RX); axis square
set(gca,'YDir','normal'); colorbar
xlabel('pixels'); ylabel('pixels')
title('X visual coordinates (cartesian)')

subplot(222)
imagesc(RY); axis square
set(gca,'YDir','normal'); colorbar
xlabel('pixels'); ylabel('pixels')
title('Y visual coordinates (cartesian)')


subplot(223)
scatter(RX(:),RY(:),60,RX(:)); axis square
xlabel('(dva)')
xlim([-5 5 ]); ylim([-5 5 ]); grid
hold on; scatter(0,0,60,'k+')
title('Visual space')

subplot(224)
scatter(RX(:),RY(:),60,RY(:)); axis square
xlim([-5 5 ]); ylim([-5 5 ]); grid
hold on; scatter(0,0,60,'k+')
xlabel('(dva)')
title('Visual space')
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
%param = [3 1.4 1.3 40 1.7 -0.2]
% param(1) = 10
%  param(2) =  1000
%  param(3) = 1000 ;
%   param(4) =50
% param(5) = 500
%  param(6) = -200
% [h w] = size(RX) ;
figure
N =30

% Take a sample of equally spaced pixels values
q = round(linspace(1,h,N));
k =round(linspace(1,w,N));

[X,Y] = meshgrid(round(linspace(1,h,N)),round(linspace(1,w,N)));
RXs = RX(q,k);
RYs = RY(q,k);
X = X(~isnan(RXs)) ;
Y = Y(~isnan(RYs) );
RXs = RXs(~isnan(RXs)) ;
RYs = RYs(~isnan(RYs) );


[x y] = RetinoModel(RXs,RYs,param);

%
 xx = [0  500]
dd = 1;
clf
subplot(221)
scatter(x,y,60,RXs,'filled'); colorbar; grid
 xlim([xx])
 ylim([xx])
 xlabel('mm'); ylabel('mm')
 title('Fit')

subplot(222)
scatter(X.*dd,Y.*dd,60,RXs,'filled'); colorbar; grid
 xlim([xx])
 ylim([xx])
 title('Real')


subplot(223)
scatter(x,y,60,RYs,'filled'); colorbar; grid
 xlim([xx])
 ylim([xx])

subplot(224)
scatter(X.*dd,Y.*dd,60,RYs,'filled'); colorbar; grid
%  set(gca,'YDir','normal'); colorbar
 xlim([xx])
 ylim([xx])


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