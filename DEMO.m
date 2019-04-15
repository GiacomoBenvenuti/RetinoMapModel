%% DEMO Retinotopic Model
%
%-------------------------------------------
% by Giacomo Benvenuti & Wahiba Taouali
% <giacomox@gmail.com>
% Repository
% https://github.com/giacomox/RetinoMapModel
%-------------------------------------------

%% Before starting
% 1. Set the project folder as Current Folder in Matlab IDE

%% Test the model using a grid

% Generate a grid in the visual space
[U V] = meshgrid(linspace(-10,10,16),linspace(-10,10,16));

% Generate a set of parameters for the model
A = 1; Bx = 3; By=2; Angle = 0; U0 = 0; V0 = 0;
test_param = [A Bx By Angle U0 V0];

% Run the model and display results
figure
[x y] = RetinoModel(U,V,test_param,1)

%% Load cortical image with retinotopic coordinates
% Load the "real data" provided in the folder

load ./testdata/testdata.mat

%% Display real data

figure

subplot(221)
scatter(RX(:),RY(:),60,RX(:)); axis square
xlabel('(dva)')
xlim([-5 5 ]); ylim([-5 5 ]); grid
hold on; scatter(0,0,60,'k+')
title('Visual space')

subplot(222)
imagesc(RX); axis square
set(gca,'YDir','normal'); colorbar
xlabel('pixels'); ylabel('pixels')
title('X visual coordinates')

subplot(223)
scatter(RX(:),RY(:),60,RY(:)); axis square
xlim([-5 5 ]); ylim([-5 5 ]); grid
hold on; scatter(0,0,60,'k+')
xlabel('(dva)')
title('Visual space')
set(gcf,'color','w')

subplot(224)
imagesc(RY); axis square
set(gca,'YDir','normal'); colorbar
xlabel('pixels'); ylabel('pixels')
title('Y visual coordinates')

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

%% Disaply fitted model

[h w] = size(RX) ;
figure
N =504;

% Take a sample of equally spaced pixels values
q = round(linspace(1,h,N));
k =round(linspace(1,w,N));

[X,Y] = meshgrid(round(linspace(1,h,N)),round(linspace(1,w,N)));
RXs = RX;%(q,k);
RYs = RY;%(q,k);


X = X(~isnan(RXs)) ;
Y = Y(~isnan(RYs) );
RXs =  RXs(~isnan(RXs)) ;
RYs = RYs(~isnan(RYs) );

%[x y] = RetinoModel(RXs,RYs,param);
[x y] = RetinoModel(RXs,RYs,param);
%
xx = [0  500]
dd = 1;
clf
subplot(221)
scatter(x,y,60,RXs,'filled'); colorbar; grid
xlim([xx])
ylim([xx])
xlabel('pixels'); ylabel('pixels')
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
xlim([xx])
ylim([xx])

%% Inverse function: a work around
% The model allows to convert any position in the visual space (u,v)
% to the correspondet position in the cortical space (x,y). 
% However, we want also to be able to convert any position 
% in the cortical space to a position in the visual space. 
% Since we cannot analytically formulate the inverse function of our model,
% we have to use a work around. This approach consists 
% in converting a large grid in the visual space to the 
% cortical space and interpolating. 

[Xq, Yq ]= meshgrid( 1:size(RX,1) , 1:size(RX,2) );
[U V] = RetinoModel_INV(Xq,Yq,param)



%%

% Generate grid in visual space
[U, V] = meshgrid( -5:.1:2 ,  -8:.1:3 );
% Estimate correspondent cortical location
[x2 y2] = RetinoModel(U,V,param);

figure; scatter(x2(:),y2(:),10,U(:))
% Rectangle correspoding to the area we want to estimate
rectangle('Position',[1 1 504 504])


%%
% Show interpolation resambles real data
figure; 
subplot(221)
scatter(X(1:gg:end),Y(1:gg:end),60,RXs(1:gg:end),'filled','MarkerEdgeColor',cc); colorbar; 
set(gca,'YDir','normal')
axis square off
xlim([0 504]); ylim([0 504])
title('Measured')

subplot(223)
scatter(X(1:gg:end),Y(1:gg:end),60,RYs(1:gg:end),'filled','MarkerEdgeColor',cc); colorbar; 
set(gca,'YDir','normal')
axis square off
xlim([0 504]); ylim([0 504])

subplot(222)
imagesc(Uq)
hold on 
% downsample real data to be able to see them
gg = 1
cc = 'none'
scatter(X(1:gg:end),Y(1:gg:end),60,RXs(1:gg:end),'filled','MarkerEdgeColor',cc); colorbar; 
set(gca,'YDir','normal')
axis square off
title('+ Model interpolation')

subplot(224)
imagesc(Vq)
set(gca,'YDir','normal')
hold on 
scatter(X(1:gg:end),Y(1:gg:end),60,RYs(1:gg:end),'filled','MarkerEdgeColor',cc); colorbar; 
axis square off
